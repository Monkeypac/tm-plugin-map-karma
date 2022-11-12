class Map {
    string m_id;
    wstring m_name;
    CGameCtnChallenge @m_ctn;

    void Set(CGameCtnChallenge @ctn, Map map) {
	print("map change `" + this.m_id + "` => `" + map.m_id);
	this.m_id = map.m_id;
	this.m_name = map.m_name;
	@this.m_ctn = ctn;
    }

    void Unset() {
	this.m_id = "";
	this.m_name = "";
	@this.m_ctn = null;
    }
}

Map GetMapInfo(CGameCtnChallenge @map) {
    Map output;
    output.m_name = map.MapName;

    if (map.MapInfo is null) {
	print("warning: map info undefined");
    } else {
	output.m_id = map.MapInfo.MapUid;
    }

    return output;
}
