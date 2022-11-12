namespace Karma {
    class Round {
	dictionary m_votes;
	dictionary m_nicknames;
	array<string> m_last_votes;
	int m_sum_votes;
	Map m_map;
	bool m_is_on;

	Round() {}

	Round(Map map) {
	    this.m_map = map;
	    this.Load();
	}

	void AddVote(const string &in user_id, const string &in input, const string &in input_nickname = "", const string &in source = "") {
	    if (!this.m_is_on) {
		return;
	    }

	    addVote(user_id, input, input_nickname, source);
	}

	void addVote(const string &in user_id, const string &in input, const string &in input_nickname, const string &in source) {
	    VoteValue value = GetVoteValueFromString(input);
	    if (value == VoteValue::Undefined) {
		return;
	    }

	    log_trace("Adding vote: UID: " + user_id + " Msg: " + input + " Nickname: " + input_nickname + " Source: " + source);

	    string old_input;
	    if (m_votes.Get(user_id, old_input)) {
		VoteValue old_value = GetVoteValueFromString(old_input);
		m_sum_votes -= old_value;
	    }
	    m_sum_votes += value;

	    m_votes.Set(user_id, input);

	    string nickname = input_nickname;
	    if (nickname == "") {
		nickname = user_id;
	    }
	    if (source != "") {
		nickname = nickname + " (" + source + ")";
	    }
	    m_nicknames.Set(user_id, nickname);
	    m_last_votes.InsertLast(GetIconFromString(input) + nickname);
	}

	void Load() {
	    this.loadLocal();
	    m_is_on = true;
	}

	void loadLocal() {
	    string saveFileURI = IO::FromStorageFolder(g_plugin.get_Version() + this.m_map.m_id);
	    if (!IO::FileExists(saveFileURI)) {
		log_trace("No savefile for map " + this.m_map.m_name + " / " + this.m_map.m_id + " (version " + g_plugin.get_Version() + ")");
		return;
	    }

	    log_trace("Loading map karma " + this.m_map.m_name + " / " + this.m_map.m_id);
	    IO::File file(saveFileURI);
	    file.Open(IO::FileMode::Read);
	    file.SetPos(0);
	    while (!file.EOF()) {
		string user_id = file.ReadLine();
		string user_nickname = file.ReadLine();
		string vote = file.ReadLine();
		log_trace("Loaded " + user_id + "(" + user_nickname + ")" + " : " + vote);
		addVote(user_id, vote, user_nickname, "");
	    }
	    file.Close();
	}

	void Save() {
	    this.m_is_on = false;
	    this.saveLocal();
	}

	void saveLocal() {
	    string saveFileURI = IO::FromStorageFolder(g_plugin.get_Version() + this.m_map.m_id);
	    IO::File file(saveFileURI);
	    file.Open(IO::FileMode::Write);
	    log_trace("Saving map karma " + this.m_map.m_name + " / " + this.m_map.m_id);
	    string[]@ keys = this.m_votes.GetKeys();
	    for (uint i = 0; i < keys.Length; i++) {
		string user_id = keys[i];
		string user_nickname = string(this.m_nicknames[user_id]);
		string vote = string(this.m_votes[user_id]);
		log_trace("Saving vote " + user_id + "(" + user_nickname + ")" + " : " + vote);
		file.WriteLine(user_id);
		file.WriteLine(user_nickname);
		file.WriteLine(vote);
	    }
	    file.Flush();
	    file.Close();
	}

	float GetScore() {
	    if (this.m_is_on && this.m_votes.GetKeys().Length > 0) {
		return this.m_sum_votes / this.m_votes.GetKeys().Length;
	    }

	    return 0;
	}

	void RenderInterfaceVoteEntries() {
	    if (!this.m_is_on) {
		return;
	    }

	    string[]@ keys = this.m_votes.GetKeys();

	    UI::Text(Icons::Users + keys.Length + Icons::Star + this.GetScore());

	    for (uint i = 0; i < keys.Length; i++) {
		string user_id = keys[i];
		string user_nickname = string(this.m_nicknames[user_id]);
		string vote = string(this.m_votes[user_id]);

		UI::Text(GetIconFromString(vote) + " " + user_nickname);
	    }
	}

	void RenderShowKarma() {
	    nvg::BeginPath();
	    nvg::FontSize(30);

	    string karmaValue = "MapKarma: " + this.GetScore();;

	    nvg::Text(vec2(20, 50), karmaValue);
	    nvg::ClosePath();
	}

	void RenderShowLastVote() {
	    if (m_last_votes.Length == 0) {
		return;
	    }

	    nvg::BeginPath();
	    nvg::FontSize(15);

	    string last_vote = m_last_votes[m_last_votes.Length - 1];

	    nvg::TextAlign(nvg::Align::Left);
	    nvg::TextBox(vec2(20, 100), 300, last_vote);
	    nvg::ClosePath();
	}
    }

    enum VoteValue {
	MinusMinus = 0,
	Minus = 25,
	MinusPlus = 50,
	Plus = 75,
	PlusPlus = 100,
	Undefined = -1
    }

    VoteValue GetVoteValueFromString(const string &in input) {
	if (input == "--") {
	    return VoteValue::MinusMinus;
	} else if (input == "-") {
	    return VoteValue::Minus;
	} else if (input == "-+" || input == "+-") {
	    return VoteValue::MinusPlus;
	} else if (input == "+") {
	    return VoteValue::Plus;
	} else if (input == "++") {
	    return VoteValue::PlusPlus;
	}

	return VoteValue::Undefined;
    }

    string GetIconFromString(const string &in input) {
	VoteValue value = GetVoteValueFromString(input);
	switch (value) {
	    case MinusMinus:
	    return Icons::MinusCircle + Icons::MinusCircle;
	    case Minus:
	    return Icons::MinusCircle;
	    case MinusPlus:
	    return Icons::MinusCircle + Icons::PlusCircle;
	    case Plus:
	    return Icons::PlusCircle;
	    case PlusPlus:
	    return Icons::PlusCircle + Icons::PlusCircle;
	}

	return Icons::TimesCircle + Icons::TimesCircle;
    }
}
