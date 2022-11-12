Map@ g_map;
Karma::Round@ g_karma;
bool g_show_karma;

void Main() {
#if TMNEXT
#if DEPENDENCY_TWITCHBASE
    print("Twitch base installed, will attempt to use Twitch functionnalities.");
    startnew(TwitchMod::Main);
#else
    print("Twitch base not installed, please install and configure to be able to use Twitch functionnalities.");
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
    print("Disabling MapKarma plugin");
    TwitchMod::OnDisabled();
}

void Render() {
    if (g_show_karma) {
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

void RenderMenu()
{
    if (UI::MenuItem("Show MapKarma", "", g_show_karma)) {
	g_show_karma = !g_show_karma;
    }
}
