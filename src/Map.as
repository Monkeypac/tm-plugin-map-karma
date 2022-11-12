class Map {
    string m_id;
    wstring m_name;

    Map() {}
}

Map GetMapInfo(CGameCtnChallenge @map) {
    Map output;
    output.m_name = map.MapName;

    if (map.MapInfo is null) {
	log_warn("warning: map info undefined");
    } else {
	output.m_id = map.MapInfo.MapUid;
    }

    return output;
}
