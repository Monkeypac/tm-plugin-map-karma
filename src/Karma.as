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
		if (old_input == input) {
		    log_trace("Ignoring vote as it is unchanged");
		    return;
		}

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
	    addLastVote(GetIconFromString(input) + nickname);
	}

	void addLastVote(const string &in input) {
	    m_last_votes.InsertLast(input);
	    if (m_last_votes.Length > Setting_ShowLastVoteCount) {
		m_last_votes.RemoveAt(0);
	    }
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

	void RenderShowKarmaMainBox() {
	    nvg::BeginPath();

	    vec2 top_left = Setting_ShowKarmaPosition;
	    vec2 bot_right = vec2(top_left.x+Setting_ShowKarmaSize.x, top_left.y+Setting_ShowKarmaSize.y);

	    nvg::RoundedRectVarying(
		top_left, vec2(bot_right.x-top_left.x, bot_right.y-top_left.y),
		Setting_ShowKarmaRadius.x, Setting_ShowKarmaRadius.y, Setting_ShowKarmaRadius.z, Setting_ShowKarmaRadius.w);

	    nvg::FillColor(Setting_ShowKarmaBackgroundColor);
	    nvg::Fill();

	    nvg::StrokeColor(Setting_ShowKarmaBorderColor);
	    nvg::Stroke();

	    nvg::ClosePath();
	}

	string GetShowKarmaMore() {
	    return Icons::Users + " " + this.m_votes.GetKeys().Length
	    + "    "
	    + Icons::Star + " " + this.GetScore();
	}

	void RenderShowKarmaBar() {
	    int minus_y = 0;
	    if (Setting_ShowKarmaShowMore) {
		nvg::FontSize(Setting_ShowKarmaFontSize);
		vec2 bounds = nvg::TextBounds(this.GetShowKarmaMore());

		minus_y = int(bounds.y);
	    }

	    vec2 top_left = vec2(
		Setting_ShowKarmaPosition.x
		+ Setting_ShowKarmaMargin.x,
		Setting_ShowKarmaPosition.y
		+ Setting_ShowKarmaMargin.y
	    );
	    vec2 bot_right = vec2(top_left.x
		+ Setting_ShowKarmaSize.x
		- 2*Setting_ShowKarmaMargin.x,
		top_left.y
		+ Setting_ShowKarmaSize.y
		- 2*Setting_ShowKarmaMargin.y
		- minus_y
	    );

	    nvg::BeginPath();

	    nvg::RoundedRectVarying(
		top_left, vec2(bot_right.x-top_left.x, bot_right.y-top_left.y),
		Setting_ShowKarmaBarRadius.x, Setting_ShowKarmaBarRadius.y, Setting_ShowKarmaBarRadius.z, Setting_ShowKarmaBarRadius.w);

	    nvg::FillColor(Setting_ShowKarmaBarBackgroundColor);
	    nvg::Fill();

	    nvg::StrokeColor(Setting_ShowKarmaBarBorderColor);
	    nvg::Stroke();

	    nvg::ClosePath();

	    uint length = this.m_votes.GetKeys().Length;
	    if (length == 0) {
		return;
	    }

	    float len_total = bot_right.x - top_left.x;
	    float score = this.GetScore();
	    float x_to_add = (score/100.0f)*len_total;
	    vec2 karma_right = vec2(
		top_left.x+x_to_add,
		bot_right.y
	    );

	    nvg::BeginPath();

	    nvg::RoundedRectVarying(
		top_left, vec2(karma_right.x-top_left.x, karma_right.y-top_left.y),
		Setting_ShowKarmaBarRadius.x, Setting_ShowKarmaBarRadius.y, Setting_ShowKarmaBarRadius.z, Setting_ShowKarmaBarRadius.w);

	    nvg::FillColor(Setting_ShowKarmaBarColor);
	    nvg::Fill();

	    nvg::ClosePath();
	}

	void RenderShowKarmaShowMore() {
	    if (!Setting_ShowKarmaShowMore) {
		return;
	    }

	    nvg::BeginPath();

	    nvg::FontSize(Setting_ShowKarmaFontSize);
	    vec2 bounds = nvg::TextBounds(this.GetShowKarmaMore());

	    vec2 text_pos = vec2(Setting_ShowKarmaPosition.x
		+ Setting_ShowKarmaMargin.x,
		Setting_ShowKarmaPosition.y
		+ Setting_ShowKarmaSize.y
		- Setting_ShowKarmaMargin.y/2
	    );

	    nvg::FillColor(Setting_ShowKarmaTextColor);
	    nvg::Text(text_pos, this.GetShowKarmaMore());

	    nvg::ClosePath();
	}

	void RenderShowKarma() {
	    this.RenderShowKarmaMainBox();
	    this.RenderShowKarmaBar();
	    this.RenderShowKarmaShowMore();
	}

	void RenderShowLastVote() {
	    if (m_last_votes.Length == 0) {
		return;
	    }

	    nvg::BeginPath();
	    nvg::FontSize(Setting_ShowLastVoteFontSize);
	    vec2 bounds = nvg::TextBounds(this.GetShowKarmaMore());
	    nvg::FillColor(Setting_ShowLastVoteColor);

	    float shift_y = 0;

	    for (uint i = 0; i < m_last_votes.Length; i++) {
		string last_vote = m_last_votes[m_last_votes.Length - 1 - i];

		nvg::Text(vec2(Setting_ShowLastVotePosition.x, Setting_ShowLastVotePosition.y+bounds.y+shift_y), last_vote);
		shift_y += bounds.y;
	    }
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
