Map@ g_map;
Karma::Round@ g_karma;

void Main() {
#if TMNEXT
#if DEPENDENCY_TWITCHBASE
    log_info("Twitch base installed, will attempt to use Twitch functionnalities.");
    startnew(TwitchMod::Main);
#else
    log_info("Twitch base not installed, please install and configure to be able to use Twitch functionnalities.");
#endif

    startnew(InGame::Main);

    while (true) {
	UpdateMap();

	yield();
    }
#endif
}

void UpdateMap() {
    auto map = GetApp().RootMap;

    if (map is null) {
	if (@g_map !is null) {
	    @g_map = null;
	    OnMapUnset();
	}
    } else {
	Map new_map = GetMapInfo(map);
	if (g_map is null) {
	    @g_map = new_map;
	    OnMapSet();
	} else {
	    if (new_map.m_id != g_map.m_id) {
		@g_map = new_map;
		OnMapSet();
	    }
	}
    }
}

void OnMapSet() {
    if (g_karma !is null) {
	g_karma.Save();
    }

    Karma::Round new_karma = Karma::Round(g_map);
    @g_karma = @new_karma;
}

void OnMapUnset() {
    if (g_karma !is null) {
	g_karma.Save();
	@g_karma = null;
    }
}

void OnDisabled() {
    log_trace("Disabling MapKarma plugin");
    TwitchMod::OnDisabled();
}

void Render() {
    if (Setting_ShowKarma) {
	nvg::BeginPath();
	nvg::FontSize(30);

	string karmaValue = "N/A";
	if (g_karma !is null) {
	    karmaValue = g_karma.String();
	}

	nvg::Text(vec2(20, 50), karmaValue);
	nvg::ClosePath();
    }
}

void RenderInterface() {
    if (g_karma !is null) {
	if (Setting_VoteEntriesItf) {
	    if (UI::Begin("MapKarma votes")) {
		g_karma.RenderInterfaceVoteEntries();
		UI::End();
	    }
	}
    }
}

void RenderMenu()
{
    if (UI::BeginMenu("Game interface")) {
	if (UI::MenuItem("Show MapKarma", "", Setting_ShowKarma)) {
	    Setting_ShowKarma = !Setting_ShowKarma;
	}
	UI::EndMenu();
    }

    if (UI::BeginMenu("Openplanet interface")) {
	if (UI::MenuItem("Show votes", "", Setting_VoteEntriesItf)) {
	    Setting_VoteEntriesItf = !Setting_VoteEntriesItf;
	}
	UI::EndMenu();
    }
}
