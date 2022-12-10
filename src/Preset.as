namespace Preset {
    string n_last_local_version = "0.0.1";
    bool n_loading = false;
    class Preset {
	string m_display_name = "";
	string m_name = "";
	Json::Value@ m_json;

	Preset() {}

	Preset(const string &in name, const string &in displayname) {
	    this.m_name = name;
	    this.m_display_name = displayname;
	}

	Preset(const string &in name, const string &in displayname, Json::Value@ input) {
	    this.m_name = name;
	    this.m_display_name = displayname;
	    @this.m_json = @input;
	}

	void Load() {
	    this.loadLocal();
	}

	void Save() {
	    this.saveLocal();
	}

	void saveLocal() {
	    saveLocal_0_0_1();
	}

	void loadLocal() {
	    if (versionExists(n_last_local_version)) {
		loadLocal_0_0_1();
	    }
	}

	bool versionExists(const string &in version) {
	    string saveFileURI = IO::FromDataFolder("MapKarmaPresets/" + version + this.m_name);
	    return IO::FileExists(saveFileURI);
	}

	void saveLocal_0_0_1() {
	    string version = "0.0.1";

	    string folderPath = IO::FromDataFolder("MapKarmaPresets");
	    IO::CreateFolder(folderPath);
	    string saveFileURI = folderPath + "/" + version + this.m_name;
	    log_trace("Saving preset " + this.m_name);

	    this.saveJson();

	    Json::ToFile(saveFileURI, this.m_json);
	}

	void loadLocal_0_0_1() {
	    string version = "0.0.1";

	    string saveFileURI = IO::FromDataFolder("MapKarmaPresets/" + version + this.m_name);
	    if (!IO::FileExists(saveFileURI)) {
	    	log_trace("No savefile for preset " + this.m_name + " (version " + version + ")");
	    	return;
	    }

	    log_trace("Loading preset " + this.m_name);

	    auto object = Json::FromFile(saveFileURI);
	    @this.m_json = @object;
	    this.loadJson();
	}

	void saveJson() {
	    auto settingsList = g_plugin.GetSettings();
	    Json::Value@ object = Json::Object();
	    for (uint i = 0; i < settingsList.Length; i ++) {
		auto setting = settingsList[i];
		string value;
		vec2 v2;
		vec3 v3;
		vec4 v4;
		Json::Value newObj;
		switch (setting.Type) {
		    case Meta::PluginSettingType::Bool:
		    object[setting.VarName] = Json::Value(setting.ReadBool());
		    break;
		    case Meta::PluginSettingType::Float:
		    object[setting.VarName] = Json::Value(setting.ReadFloat());
		    break;
		    case Meta::PluginSettingType::Double:
		    object[setting.VarName] = Json::Value(setting.ReadDouble());
		    break;
		    case Meta::PluginSettingType::Int8:
		    object[setting.VarName] = Json::Value(setting.ReadInt8());
		    break;
		    case Meta::PluginSettingType::Int16:
		    object[setting.VarName] = Json::Value(setting.ReadInt16());
		    break;
		    case Meta::PluginSettingType::Int32:
		    object[setting.VarName] = Json::Value(setting.ReadInt32());
		    break;
		    case Meta::PluginSettingType::String:
		    object[setting.VarName] = Json::Value(setting.ReadString());
		    break;
		    case Meta::PluginSettingType::Vec2:
		    v2 = setting.ReadVec2();
		    newObj = Json::Object();
		    newObj["x"] = v2.x;
		    newObj["y"] = v2.y;
		    object[setting.VarName] = newObj;
		    break;
		    case Meta::PluginSettingType::Vec3:
		    v3 = setting.ReadVec3();
		    newObj = Json::Object();
		    newObj["x"] = v3.x;
		    newObj["y"] = v3.y;
		    newObj["z"] = v3.z;
		    object[setting.VarName] = newObj;
		    break;
		    case Meta::PluginSettingType::Vec4:
		    v4 = setting.ReadVec4();
		    newObj = Json::Object();
		    newObj["x"] = v4.x;
		    newObj["y"] = v4.y;
		    newObj["z"] = v4.z;
		    newObj["w"] = v4.w;
		    object[setting.VarName] = newObj;
		    break;
		    case Meta::PluginSettingType::Uint8:
		    object[setting.VarName] = Json::Value(setting.ReadUint8());
		    break;
		    case Meta::PluginSettingType::Uint16:
		    object[setting.VarName] = Json::Value(setting.ReadUint16());
		    break;
		    case Meta::PluginSettingType::Uint32:
		    object[setting.VarName] = Json::Value(setting.ReadUint32());
		    break;
		    default:
		    log_warn("unkown setting type for variable: " + setting.VarName);
		    break;
		}
	    }

	    @this.m_json = @object;
	}

	void loadJson() {
	    n_loading = true;

	    auto object = @this.m_json;

	    if (object is null) {
		n_loading = false;
		this.Load();
		return;
	    }

	    auto settingsList = g_plugin.GetSettings();
	    for (uint i = 0; i < settingsList.Length; i ++) {
		auto setting = settingsList[i];

		if (!object.HasKey(setting.VarName)) {
		    log_warn("setting " + setting.VarName + " is not in preset " + this.m_name);
		    continue;
		}

		auto value = object[setting.VarName];
		switch (setting.Type) {
		    case Meta::PluginSettingType::Bool:
		    if (value.GetType() != Json::Type::Boolean) break;
		    setting.WriteBool(bool(value));
		    break;
		    case Meta::PluginSettingType::Float:
		    if (value.GetType() != Json::Type::Number) break;
		    setting.WriteFloat(float(value));
		    break;
		    case Meta::PluginSettingType::Double:
		    if (value.GetType() != Json::Type::Number) break;
		    setting.WriteDouble(double(value));
		    break;
		    case Meta::PluginSettingType::Int8:
		    if (value.GetType() != Json::Type::Number) break;
		    setting.WriteInt8(int8(value));
		    break;
		    case Meta::PluginSettingType::Int16:
		    if (value.GetType() != Json::Type::Number) break;
		    setting.WriteInt16(int16(value));
		    break;
		    case Meta::PluginSettingType::Int32:
		    if (value.GetType() != Json::Type::Number) break;
		    setting.WriteInt32(int(value));
		    break;
		    case Meta::PluginSettingType::String:
		    if (value.GetType() != Json::Type::String) break;
		    setting.WriteString(string(value));
		    break;
		    case Meta::PluginSettingType::Vec2:
		    if (value.GetType() != Json::Type::Object) break;
		    setting.WriteVec2(vec2(value.Get("x", 0), value.Get("y", 0)));
		    break;
		    case Meta::PluginSettingType::Vec3:
		    if (value.GetType() != Json::Type::Object) break;
		    setting.WriteVec3(vec3(value.Get("x", 0), value.Get("y", 0), value.Get("z", 0)));
		    break;
		    case Meta::PluginSettingType::Vec4:
		    if (value.GetType() != Json::Type::Object) break;
		    setting.WriteVec4(vec4(value.Get("x", 0), value.Get("y", 0), value.Get("z", 0), value.Get("w", 0)));
		    break;
		    case Meta::PluginSettingType::Uint8:
		    if (value.GetType() != Json::Type::Number) break;
		    setting.WriteUint8(uint8(value));
		    break;
		    case Meta::PluginSettingType::Uint16:
		    if (value.GetType() != Json::Type::Number) break;
		    setting.WriteUint16(uint16(value));
		    break;
		    case Meta::PluginSettingType::Uint32:
		    if (value.GetType() != Json::Type::Number) break;
		    setting.WriteUint32(uint32(value));
		    break;
		    default:
		    log_warn("unkown setting type for variable: " + setting.VarName);
		    break;
		}
	    }
	    n_loading = false;
	}
    }

    bool n_updating = false;
    Preset@ defaultPreset;
    array<Preset@> n_presets;
    string n_remote_url = "https://openplanet.dev/plugin/mapkarma/config/presets";

    void LoadPresetsFromRemote() {
	n_updating = true;

	n_presets.RemoveRange(0, n_presets.Length);
	string url = n_remote_url;
	auto req = Net::HttpGet(url);
	while (!req.Finished()) {
	    yield();
	}

	const auto js = Json::Parse(req.String());
	if (js.GetType() != Json::Type::Object) {
	    log_warn("preset config from remote has an error");
	    n_updating = false;
	    return;
	}

	auto keys = js.GetKeys();
	for (uint i = 0; i < keys.Length; i++) {
	    log_trace("Preset remote: " + keys[i]);
	    auto preset = Preset(keys[i], "[Default] " + keys[i], js[keys[i]]);
	    n_presets.InsertLast(preset);
	}

	@defaultPreset = n_presets[0];

	string userPresetsFolder = IO::FromDataFolder("MapKarmaPresets");
	auto files = IO::IndexFolder(userPresetsFolder, false);
	for (uint i = 0; i < files.Length; i++) {
	    string filename = files[i].SubStr(userPresetsFolder.Length + 1 + n_last_local_version.Length);
	    log_trace("Preset custom: " + filename + " " + userPresetsFolder +"/"+ n_last_local_version+ filename);
	    auto object = Json::FromFile(userPresetsFolder +"/"+ n_last_local_version + filename);
	    n_presets.InsertLast(Preset(filename, "[Custom] " + filename, object));
	}

	n_updating = false;
    }

    Preset@ Add(const string &in input) {
	if (n_updating) {
	    return defaultPreset;
	}

	auto preset = Preset(input, "[Custom] " + input);
	preset.Save();
	n_presets.InsertLast(preset);

	return @preset;
    }
}
