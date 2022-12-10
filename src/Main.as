Map@ g_map;
Karma::Round@ g_karma;
Meta::Plugin@ g_plugin;
Karma::TexturedBar@ g_textured_bar;
dictionary g_fonts;

void Main() {
#if TMNEXT
    @g_plugin = Meta::ExecutingPlugin();
#if DEPENDENCY_TWITCHBASE
    log_info("Twitch base installed, will attempt to use Twitch functionnalities.");
    startnew(TwitchMod::Main);
#else
    log_info("Twitch base not installed, please install and configure to be able to use Twitch functionnalities.");
#endif

    startnew(InGame::Main);

    startnew(Preset::LoadPresetsFromRemote);

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

#if DEPENDENCY_TWITCHBASE
    if (Setting_SendTwitchMessageOnMapChange) TwitchMod::SendMessage(Setting_TwitchMessageOnMapChange + " " + g_map.m_name);
#endif
}

void OnMapUnset() {
    if (g_karma !is null) {
	g_karma.Save();
	@g_karma = null;
    }
}

void OnDisabled() {
    log_trace("Disabling MapKarma plugin");
    if (g_karma !is null) {
	g_karma.Save();
    }

#if DEPENDENCY_TWITCHBASE
    TwitchMod::OnDisabled();
#endif
}

void OnDestroyed() {
    OnDisabled();
}

void Render() {
    if (g_textured_bar is null) {
    	@g_textured_bar = Karma::TexturedBar();
    }

    if (Setting_ShowKarma && g_karma !is null) {
    	g_karma.RenderShowKarma();
    }

    if (Setting_ShowLastVote && g_karma !is null) {
    	g_karma.RenderShowLastVote();
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

    if (Setting_ChangeKarmaPositions) {
	UI::SetNextWindowSize(int(Setting_ShowKarmaSize.x), int(Setting_ShowKarmaSize.y));
	UI::SetNextWindowPos(int(Setting_ShowKarmaPosition.x), int(Setting_ShowKarmaPosition.y));
	if (UI::Begin("Karma bar - move and resize")) {
	    Setting_ShowKarmaPosition = UI::GetWindowPos();
	    Setting_ShowKarmaSize = UI::GetWindowSize();
	    UI::End();
	}

	UI::SetNextWindowSize(200, 200);
	UI::SetNextWindowPos(int(Setting_ShowLastVotePosition.x), int(Setting_ShowLastVotePosition.y));
	if (UI::Begin("Karma last vote - move")) {
	    Setting_ShowLastVotePosition = UI::GetWindowPos();
	    UI::End();
	}

	UI::SetNextWindowSize(200, 50);
	UI::SetNextWindowPos(int(Setting_ShowKarmaDetailsPosition.x), int(Setting_ShowKarmaDetailsPosition.y));
	if (UI::Begin("Karma details - move")) {
	    Setting_ShowKarmaDetailsPosition = UI::GetWindowPos();
	    UI::End();
	}
    }
}

void RenderMenu()
{
    if (UI::BeginMenu("Map karma")) {
	if (UI::BeginMenu("Game interface")) {
	    if (UI::MenuItem("Show bar", "", Setting_ShowKarma)) {
		Setting_ShowKarma = !Setting_ShowKarma;
	    }
	    if (UI::MenuItem("Show last vote", "", Setting_ShowLastVote)) {
		Setting_ShowLastVote = !Setting_ShowLastVote;
	    }
	    UI::EndMenu();
	}

	if (UI::BeginMenu("Openplanet interface")) {
	    if (UI::MenuItem("Show votes", "", Setting_VoteEntriesItf)) {
		Setting_VoteEntriesItf = !Setting_VoteEntriesItf;
	    }
	    if (UI::MenuItem("Move and resize", "", Setting_ChangeKarmaPositions)) {
		Setting_ChangeKarmaPositions = !Setting_ChangeKarmaPositions;
	    }
	    UI::EndMenu();
	}

	if (UI::BeginMenu("Administrate")) {
	    if (UI::MenuItem("Reload textures", "", false)) {
		@g_textured_bar = null;
	    }
	    UI::EndMenu();
	}
	UI::EndMenu();
    }
}

void NvgLoadFont(const string &in path) {
    int value;

    if (g_fonts.Get(path, value)) {
    	nvg::FontFace(value);
    	return;
    }

    value = nvg::LoadFont(path, true, true);

    g_fonts.Set(path, value);
    NvgLoadFont(path);
}
