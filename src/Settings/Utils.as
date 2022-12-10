string RenderSettingsSelectableList(string &in setting, array<string> list) {
    string output = setting;

    for (uint i = 0; i < list.Length; i++) {
	auto listname = list[i];

	string name = listname;

	if (UI::Selectable(name, output == listname)) {
	    output = listname;
	}

	if (output == listname) {
	    UI::SetItemDefaultFocus();
	}
    }

    return output;
}

array<string> RuntimeSetting_AvailableFonts;

// This was taken from Miss's BetterChat Plugin
string RenderSettingsFontName(const string &in label, const string &in input) {
    string userFontsFolder = IO::FromDataFolder("Fonts");
    string output = input;

    UI::TextWrapped(
	"To use custom fonts, place your ttf fonts here: " + userFontsFolder
    );

    if (UI::BeginCombo(label, output)) {
	if (UI::IsWindowAppearing()) {
	    RuntimeSetting_AvailableFonts.RemoveRange(0, RuntimeSetting_AvailableFonts.Length);

	    string systemFontsFolder = IO::FromAppFolder("Openplanet/Fonts");
	    auto files = IO::IndexFolder(systemFontsFolder, false);
	    for (uint i = 0; i < files.Length; i++) {
		string filename = files[i].SubStr(systemFontsFolder.Length + 1);
		if (!filename.EndsWith(".ttf")) {
		    continue;
		}
		RuntimeSetting_AvailableFonts.InsertLast(filename);
	    }

	    files = IO::IndexFolder(userFontsFolder, false);
	    for (uint i = 0; i < files.Length; i++) {
		string filename = files[i].SubStr(userFontsFolder.Length + 1);
		if (!filename.EndsWith(".ttf")) {
		    continue;
		}
		RuntimeSetting_AvailableFonts.InsertLast(filename);
	    }
	}

	output = RenderSettingsSelectableList(output, RuntimeSetting_AvailableFonts);

	UI::EndCombo();
    }

    return output;
}

string RenderSettingsIcon(const string &in label, const string &in value) {
    string output = value;

    if (UI::BeginTable(label, 2)) {
	UI::TableNextColumn();

	string iconValue = UI::InputText(label, output);
	if (iconValue != output) {
	    output = iconValue;
	}

	UI::TableNextColumn();

	if (UI::BeginCombo("Pick from list", output)) {
	    output = RenderSettingsSelectableList(output, OP_Icons);

	    UI::EndCombo();
	}
	UI::EndTable();
    }

    return output;
}

Preset::Preset@ RenderSettingsPresetsList(const string &in label, Preset::Preset@ input) {
    Preset::Preset@ output = input;
    string userPresetsFolder = IO::FromDataFolder("Presets");

    UI::TextWrapped(
	"To use custom presets, place your presets here: " + userPresetsFolder
    );

    if (UI::BeginTable("Load preset table", 2)) {
	UI::TableNextColumn();
	if (UI::BeginCombo(label, output.m_name)) {
	    if (UI::IsWindowAppearing()) {
		RuntimeSetting_PresetList.RemoveRange(0, RuntimeSetting_PresetList.Length);

		for (uint i = 0; i < Preset::n_presets.Length; i++) {
		    RuntimeSetting_PresetList.InsertLast(Preset::n_presets[i]);
		}
	    }

	    for (uint i = 0; i < RuntimeSetting_PresetList.Length; i++) {
		auto listname = RuntimeSetting_PresetList[i].m_display_name;

		string name = listname;

		if (UI::Selectable(name, output.m_display_name == listname)) {
		    output = RuntimeSetting_PresetList[i];
		}

		if (output.m_display_name == listname) {
		    UI::SetItemDefaultFocus();
		}
	    }

	    UI::EndCombo();
	}
	UI::TableNextColumn();
	if (UI::Button("Load selected preset")) {
	    log_trace("Loading preset " + RuntimeSetting_Preset.m_name);

	    // Just be double sure that the positions won't rechange instantly while loading
	    Setting_ChangeKarmaPositions = false;
	    RuntimeSetting_Preset.loadJson();
	    Setting_ChangeKarmaPositions = false;
	    @g_textured_bar = null;
	}
	UI::EndTable();
    }

    return output;
}
