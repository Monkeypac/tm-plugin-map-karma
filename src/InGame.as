namespace InGame {
    // Mostly taken from Miss's BetterChat/ChatMessageLoop
    void Main() {
	auto network = GetApp().Network;

	uint lastTime = 0;
	if (network.ChatHistoryTimestamp.Length > 0) {
	    lastTime = network.ChatHistoryTimestamp[0];
	}

	while (true) {
	    uint highestTime = 0;

	    for (uint i = 0; i < network.ChatHistoryTimestamp.Length; i++) {
		string line = string(network.ChatHistoryLines[i]);
		uint time = network.ChatHistoryTimestamp[i];

		line = line.Replace("\n", " ");

		// Sometimes, the most recent message is empty in the history lines for 1 frame, so we ignore any empty lines.
		// If we do that before we handle timestamps, we can resume on messages that get their line filled in on the next frame.
		if (line == "") {
		    continue;
		}

		// Stop if we've reached the time since the last poll
		if (time <= lastTime) {
		    break;
		}

		// Remember the highest timestamp
		if (time > highestTime) {
		    highestTime = time;
		}

		OnMessage(line);
	    }

	    if (highestTime > 0) {
		lastTime = highestTime;
	    }

	    yield();
	}
    }

    void OnMessage(const string &in line) {
	string authorName;
	string authorLogin;
	string authorNickname;

	//NOTE: we can't keep this handle around because it will be invalidated on disconnect
	CGamePlayer@ authorPlayer;
	CGamePlayerInfo@ authorPlayerInfo;

	string text;

	// If the line starts with "$FFFCHAT_JSON:", we have a json object providing us juicy details
	//NOTE: The "$FFF" at the start is prepended by the game to chat messages sent through XMLRPC (for whatever reason)
	if (line.StartsWith("$FFFCHAT_JSON:")) {
	    auto js = Json::Parse(line.SubStr(14));

	    if (js.HasKey("login")) {
		authorLogin = js["login"];
	    }

	    if (js.HasKey("nickname")) {
		authorNickname = js["nickname"];
	    }

	    if (js.HasKey("text")) {
		text = js["text"];
	    }

	    @authorPlayer = FindPlayerByLogin(authorLogin);
	    if (authorPlayer !is null) {
		@authorPlayerInfo = authorPlayer.User;
	    } else {
		@authorPlayerInfo = FindPlayerInfoByLogin(authorLogin);
	    }

	    if (authorPlayerInfo !is null) {
		authorName = authorPlayerInfo.Name;
	    }

	} else {
	    //TODO: This regex only works for basic uplay player names!
	    auto parse = Regex::Match(line, "^(\\$FFF)?([<\\[])\\$<([^\\$]+)\\$>[\\]>] ([\\S\\s]*)");
	    if (parse.Length > 0) {
		authorName = parse[3];
		text = parse[4];
	    } else {
		// Check if this is an EvoSC message
		parse = Regex::Match(line, "^\\$FFF\\$z\\$s(\\$[0-9a-fA-F]{3}.+)\\[\\$<\\$<\\$fff\\$eee(.*)\\$>\\$>\\]\\$z\\$s ([\\S\\s]*)");
		if (parse.Length > 0) {
		    authorName = parse[1] + "$z " + parse[2];
		    text = parse[3];
		} else {
		    // This is a system message (or something else)
		    text = line;
		}
	    }

	    // If we have an author display name, find the player associated
	    @authorPlayer = FindPlayerByName(authorName);
	    if (authorPlayer !is null) {
		@authorPlayerInfo = authorPlayer.User;
	    } else {
		@authorPlayerInfo = FindPlayerInfoByName(authorName);
	    }

	    if (authorPlayerInfo !is null) {
		authorLogin = authorPlayerInfo.Login;
	    }
	}

	// Get some more information about this player
	auto network = cast<CTrackManiaNetwork>(GetApp().Network);

	string authorId;

	if (authorPlayerInfo !is null) {
	    authorId = authorPlayerInfo.WebServicesUserId;
	}

	// Count vote
	if (@g_karma !is null) {
	    g_karma.AddVote(authorId, text, authorName, "Trackmania");
	}
    }

    CGamePlayer@ FindPlayerByName(const string &in name)
    {
	if (name == "") {
	    return null;
	}

	auto pg = GetApp().CurrentPlayground;
	if (pg is null) {
	    return null;
	}

	for (uint i = 0; i < pg.Players.Length; i++) {
	    auto player = cast<CGamePlayer>(pg.Players[i]);
	    if (player.User.Name == name) {
		return player;
	    }
	}

	return null;
    }

    CGamePlayerInfo@ FindPlayerInfoByName(const string &in name)
    {
	if (name == "") {
	    return null;
	}

	auto network = GetApp().Network;
	for (uint i = 0; i < network.PlayerInfos.Length; i++) {
	    auto player = cast<CGamePlayerInfo>(network.PlayerInfos[i]);
	    if (player.Name == name) {
		return player;
	    }
	}

	return null;
    }

    CGamePlayer@ FindPlayerByLogin(const string &in login)
    {
	if (login == "") {
	    return null;
	}

	auto pg = GetApp().CurrentPlayground;
	if (pg is null) {
	    return null;
	}

	for (uint i = 0; i < pg.Players.Length; i++) {
	    auto player = cast<CGamePlayer>(pg.Players[i]);
	    if (player.User.Login == login) {
		return player;
	    }
	}

	return null;
    }

    CGamePlayerInfo@ FindPlayerInfoByLogin(const string &in login)
    {
	if (login == "") {
	    return null;
	}

	auto network = GetApp().Network;
	for (uint i = 0; i < network.PlayerInfos.Length; i++) {
	    auto player = cast<CGamePlayerInfo>(network.PlayerInfos[i]);
	    if (player.Login == login) {
		return player;
	    }
	}

	return null;
    }
}
