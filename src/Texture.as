namespace Karma {
    const string n_steps_key = "steps";
    const string n_at_key = "at";
    const string n_texture_key = "texture";

    class TexturedBar {
	array<nvg::Texture@> m_textures;
	array<float> m_steps;
	bool m_is_on = false;
	string m_folder_name;

	TexturedBar() {
	    if (Setting_ShowKarmaCustomTexturesDir == "") {
		return;
	    }

	    string folder_name = Setting_ShowKarmaCustomTexturesDir;
	    if (!folder_name.EndsWith("/")) {
		folder_name += "/";
	    }
	    string folder = IO::FromDataFolder(folder_name);
	    if (!IO::FolderExists(folder)) {
		log_warn("texturedbar: folder " + folder + " does not exist");
		return;
	    }

	    string manifestURI = IO::FromDataFolder(folder_name + "manifest.json");
	    if (!IO::FileExists(manifestURI)) {
		log_warn("texturedbar: manifest: not found " + manifestURI);
		return;
	    }

	    log_trace("texturedbar: manifest found " + manifestURI);

	    auto manifest = Json::FromFile(manifestURI);
	    if (manifest is null) {
		log_warn("texturedbar: manifest: error, couldn't read");
	    }

	    if (manifest.GetType() != Json::Type::Object) {
		log_warn("texturedbar: manifest: wrong type: " + manifest.GetType());
		return;
	    }

	    if (!manifest.HasKey(n_steps_key)) {
		log_warn("texturedbar: manifest: missing " + n_steps_key + " key");
		return;
	    }

	    auto stepsJsonValue = manifest[n_steps_key];

	    if (stepsJsonValue.GetType() != Json::Type::Array) {
		log_warn("texturedbar: manifest: wrong " + n_steps_key + " key");
		return;
	    }

	    for (uint i = 0; i < stepsJsonValue.Length; i++) {
		auto subObj = stepsJsonValue[i];

		auto atKey = subObj.Get(n_at_key);
		if (atKey.GetType() != Json::Type::Number) {
		    log_warn("texturedbar: step: " + i + ": wrong " + n_at_key + " key");
		    continue;
		}

		auto textureKey = subObj.Get(n_texture_key);
		if (textureKey.GetType() != Json::Type::String) {
		    log_warn("texturedbar: step: " + i + ": wrong " + n_texture_key + " key");
		    continue;
		}

		string textureURI = IO::FromDataFolder(folder_name + string(textureKey));
		if (!IO::FileExists(textureURI)) {
		    log_warn("texturedbar: step: " + i + ": no file found " + textureURI);
		    continue;
		}

		IO::File file(textureURI);
		file.Open(IO::FileMode::Read);
		file.SetPos(0);
		string fileContent = file.ReadToEnd();
		file.Close();
		MemoryBuffer@ memoryBuffer = MemoryBuffer();
		memoryBuffer.Write(fileContent);

		nvg::Texture@ newTexture = nvg::LoadTexture(memoryBuffer);
		if (newTexture is null) {
		    log_warn("texturedbar: step: " + i + ": couldn't load texture " + textureURI);
		    continue;
		}

		m_textures.InsertLast(newTexture);
		m_steps.InsertLast(float(atKey));

		log_trace("texturedbar: step: " + i + ": at " + int(atKey) + " texture is " + string(textureKey) + " from file " + textureURI);
	    }

	    if (m_steps.Length > 0) {
		this.m_is_on = true;
		this.m_folder_name = Setting_ShowKarmaCustomTexturesDir;
	    }
	}

	nvg::Texture@ GetTexture(float value) {
	    if (value <= 0.0f) {
		value = 0.0f;
	    }
	    if (m_steps.Length != m_textures.Length || m_steps.Length <= 0 || m_textures.Length <= 0) {
		return null;
	    }

	    uint step = 0;
	    for (uint i = 0; i < m_steps.Length; i++) {
		if (value > m_steps[i]) {
		    step = i;
		} else {
		    break;
		}
	    }

	    return m_textures[step];
	}
    }
}
