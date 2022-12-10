float RuntimeSetting_MaxWindowSize = 0;

[SettingsTab name="General" icon="Cog"]
void RenderSettingsGeneral() {
    if (Preset::n_loading) {
	return;
    }
    // Fetch window size for sliders
    auto windowSize = UI::GetWindowSize();
    if (RuntimeSetting_MaxWindowSize < windowSize.x) {
	RuntimeSetting_MaxWindowSize = windowSize.x;
    }
    if (RuntimeSetting_MaxWindowSize < windowSize.y) {
	RuntimeSetting_MaxWindowSize = windowSize.y;
    }

    Setting_ChangeKarmaPositions = UI::Checkbox("Move karma windows", Setting_ChangeKarmaPositions);
    if (UI::BeginTable("show buttons", 3)) {
	UI::TableNextColumn();
	Setting_ShowKarmaShowDetails = UI::Checkbox("Show details", Setting_ShowKarmaShowDetails);
	UI::TableNextColumn();
	Setting_ShowKarmaShowDetailsInBar = UI::Checkbox("Show details in bar", Setting_ShowKarmaShowDetailsInBar);
	UI::TableNextColumn();
	Setting_ShowLastVote = UI::Checkbox("Show last vote", Setting_ShowLastVote);
	UI::EndTable();
    }
    Setting_SendTwitchMessageOnMapChange = UI::Checkbox("Whether to send a message when votes are available for a map", Setting_SendTwitchMessageOnMapChange);
    RuntimeSetting_Preset = RenderSettingsPresetsList("Select preset", RuntimeSetting_Preset);
}

[SettingsTab name="Bar" icon="Kenney::Rows"]
void RenderSettingsKarmaBar() {
    UI::TextWrapped("Box settings");
    Setting_ShowKarmaPosition = UI::SliderFloat2("Box position", Setting_ShowKarmaPosition, 0, RuntimeSetting_MaxWindowSize);
    Setting_ShowKarmaSize = UI::SliderFloat2("Box size", Setting_ShowKarmaSize, 0, RuntimeSetting_MaxWindowSize);
    Setting_ShowKarmaBorderColor = UI::InputColor4("Box border color", Setting_ShowKarmaBorderColor);
    Setting_ShowKarmaBackgroundColor = UI::InputColor4("Box background color", Setting_ShowKarmaBackgroundColor);
    Setting_ShowKarmaMargin = UI::SliderFloat2("Margin", Setting_ShowKarmaMargin, 0, RuntimeSetting_MaxWindowSize);
    Setting_ShowKarmaRadius = UI::SliderFloat4("Box radius", Setting_ShowKarmaRadius, 0, RuntimeSetting_MaxWindowSize);

    UI::TextWrapped("Bar settings");
    Setting_ShowKarmaBarColor = UI::InputColor4("Bar color", Setting_ShowKarmaBarColor);
    Setting_ShowKarmaBarBackgroundColor = UI::InputColor4("Bar background color", Setting_ShowKarmaBarBackgroundColor);
    Setting_ShowKarmaBarBorderColor = UI::InputColor4("Bar border color", Setting_ShowKarmaBarBorderColor);

    UI::TextWrapped("Textures settings");
    Setting_ShowKarmaCustomTexturesDir = UI::InputText("Custom textures folder", Setting_ShowKarmaCustomTexturesDir);
}


[SettingsTab name="Details" icon="Search"]
void RenderSettingsDetails() {
    Setting_ShowKarmaShowDetails = UI::Checkbox("Show details", Setting_ShowKarmaShowDetails);
    Setting_ShowKarmaShowDetailsInBar = UI::Checkbox("Show details in bar", Setting_ShowKarmaShowDetailsInBar);
    Setting_ShowKarmaDetailsPosition = UI::SliderFloat2("Details position", Setting_ShowKarmaDetailsPosition, 0, RuntimeSetting_MaxWindowSize);
    Setting_ShowKarmaDetailsFontSize = UI::SliderInt("Details text size", Setting_ShowKarmaDetailsFontSize, 0, Setting_MaxFontSize);
    Setting_ShowKarmaDetailsTextColor = UI::InputColor4("Details text color", Setting_ShowKarmaDetailsTextColor);
    Setting_ShowKarmaDetailsFont = RenderSettingsFontName("Details font", Setting_ShowKarmaDetailsFont);
}

[SettingsTab name="LastVote" icon="History"]
void RenderSettingsLastVote() {
    Setting_ShowLastVote = UI::Checkbox("Show last vote", Setting_ShowLastVote);
    Setting_ShowLastVoteFontSize = UI::SliderInt("Last vote text size", Setting_ShowLastVoteFontSize, 0, Setting_MaxFontSize);
    Setting_ShowLastVotePosition = UI::SliderFloat2("Last vote position", Setting_ShowLastVotePosition, 0, RuntimeSetting_MaxWindowSize);
    Setting_ShowLastVoteColor = UI::InputColor4("Last vote color", Setting_ShowLastVoteColor);
    Setting_ShowLastVoteCount = UI::SliderInt("Last vote count", Setting_ShowLastVoteCount, 0, Setting_MaxLastVote);
    Setting_ShowLastVoteFont = RenderSettingsFontName("Last vote font", Setting_ShowLastVoteFont);
}


[SettingsTab name="Icons" icon="PaintBrush"]
void RenderSettingsIcons() {
    Setting_IconMinusMinus = RenderSettingsIcon("Vote icon --", Setting_IconMinusMinus);
    Setting_IconMinus = RenderSettingsIcon("Vote icon -", Setting_IconMinus);
    Setting_IconMinusPlus = RenderSettingsIcon("Vote icon -+/+-", Setting_IconMinusPlus);
    Setting_IconPlus = RenderSettingsIcon("Vote icon +", Setting_IconPlus);
    Setting_IconPlusPlus = RenderSettingsIcon("Vote icon ++", Setting_IconPlusPlus);
    Setting_IconNbVotants = RenderSettingsIcon("Icon number votants", Setting_IconNbVotants);
    Setting_IconScore = RenderSettingsIcon("Icon score", Setting_IconScore);
}

[SettingsTab name="Twitch" icon="Twitch"]
void RenderSettingsTwitch() {
#if DEPENDENCY_TWITCHBASE
    Setting_SendTwitchMessageOnMapChange = UI::Checkbox("Whether to send a message when votes are available for a map", Setting_SendTwitchMessageOnMapChange);
    Setting_TwitchMessageOnMapChange = UI::InputText("Message to show when sending a vote notification on Twitch channel", Setting_TwitchMessageOnMapChange);
#endif
}

array<Preset::Preset@> RuntimeSetting_PresetList;
Preset::Preset@ RuntimeSetting_Preset = Preset::Preset("Current", "Current");
string RuntimeSetting_PresetName;

[SettingsTab name="Preset" icon="Kenney::Save"]
void RenderSettingsPreset() {
    RuntimeSetting_Preset = RenderSettingsPresetsList("Select preset", RuntimeSetting_Preset);
    if(UI::BeginTable("Save preset table", 2)) {
	UI::TableNextColumn();
	RuntimeSetting_PresetName = UI::InputText("Preset name", RuntimeSetting_PresetName);
	UI::TableNextColumn();
	UI::BeginDisabled(RuntimeSetting_PresetName == "");
	if (UI::Button("Save current settings")) {
	    if (RuntimeSetting_PresetName.Length > 0) {
		RuntimeSetting_Preset = Preset::Add(RuntimeSetting_PresetName);
	    }
	}
	UI::EndDisabled();
    	UI::EndTable();
    }
}
