namespace Karma {
    class Round {
	dictionary m_votes;
	int m_sum_votes;
	Map m_map;
	bool m_is_on;

	Round() {}

	Round(Map map) {
	    this.m_map = map;
	    this.Load();
	}

	void AddVote(const string &in user_id, const string &in input) {
	    if (!this.m_is_on) {
		return;
	    }

	    addVote(user_id, input);
	}

	void addVote(const string &in user_id, const string &in input) {
	    VoteValue value = GetVoteValueFromString(input);
	    if (value == VoteValue::Undefined) {
		return;
	    }

	    string old_input;
	    if (m_votes.Get(user_id, old_input)) {
		VoteValue old_value = GetVoteValueFromString(old_input);
		m_sum_votes -= old_value;
	    }
	    m_sum_votes += value;

	    m_votes.Set(user_id, input);
	    this.Log();
	}

	void Load() {
	    this.loadLocal();
	    m_is_on = true;
	}

	void loadLocal() {
	    string saveFileURI = IO::FromStorageFolder(this.m_map.m_id);
	    if (!IO::FileExists(saveFileURI)) {
		return;
	    }

	    IO::File file(saveFileURI);
	    file.Open(IO::FileMode::Read);
	    file.SetPos(0);
	    while (!file.EOF()) {
		string user_id = file.ReadLine();
		string vote = file.ReadLine();
		addVote(user_id, vote);
	    }
	    file.Close();
	}

	void Save() {
	    this.m_is_on = false;
	    this.saveLocal();
	}

	void saveLocal() {
	    string saveFileURI = IO::FromStorageFolder(this.m_map.m_id);
	    IO::File file(saveFileURI);
	    file.Open(IO::FileMode::Write);
	    string[]@ keys = this.m_votes.GetKeys();
	    for (uint i = 0; i < keys.Length; i++) {
		string user_id = keys[i];
		string vote = string(this.m_votes[user_id]);
		file.WriteLine(user_id);
		file.WriteLine(vote);
	    }
	    file.Flush();
	    file.Close();
	}

	void Log() {
	    string[]@ keys = this.m_votes.GetKeys();
	    for (uint i = 0; i < keys.Length; i++) {
		string key = keys[i];
		print(key + ": " + string(this.m_votes[key]) + " (total: " + this.GetScore() + ")");
	    }
	}

	float GetScore() {
	    if (this.m_is_on && this.m_votes.GetKeys().Length > 0) {
		return this.m_sum_votes / this.m_votes.GetKeys().Length;
	    }

	    return 0;
	}

	string String() {
	    return "MapKarma: " + this.GetScore();
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
}
