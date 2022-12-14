#if DEPENDENCY_TWITCHBASE
namespace TwitchMod {
    int n_pluginId;
    string[] n_channels;
    string n_currentChannel;
    array<Twitch::Message@> n_messages;

    void Main() {
	while (!Twitch::ChannelsAdded()) yield();
	array<Twitch::ChannelState@> channels = Twitch::GetAllChannels();

	for (uint i = 0; i < channels.Length; i++) {
	    n_channels.InsertLast(channels[i].m_name);
	}

	startnew(ChannelsLazyUpdate);
	if (n_channels.Length > 0) n_currentChannel = n_channels[0];
	while (true) {
	    if (n_pluginId == 0) {
		n_pluginId = Twitch::Register(0xFFF);
	    }
	    array<Twitch::Message@> newMessages = Twitch::Fetch(n_pluginId);
	    for (uint i = 0; i < newMessages.Length; i++) {
		onMessage(newMessages[i]);
	    }
	    yield();
	}
    }

    void SendMessage(const string &in msg) {
	if (n_pluginId == 0) {
	    log_warn("Twitch plugin not loaded yet, won't send message");
	    return;
	}
	log_trace("Trying to send message to twitch channel " + n_currentChannel + " ==> " + msg);
	Twitch::SendMessage(n_currentChannel, StripFormatCodes(msg));
    }

    void onMessage(Twitch::Message@ message) {
	if (@g_karma !is null) {
	    g_karma.AddVote(message.m_username, message.m_text, message.m_username, "Twitch");
	}
    }

    void ChannelsLazyUpdate() {
	while (!Twitch::ChannelsJoined()) yield();
	array<Twitch::ChannelState@> channels = Twitch::GetAllChannels();
	n_channels.RemoveRange(0,n_channels.Length);
	for (uint i = 0; i < channels.Length; i++) {
	    n_channels.InsertLast(channels[i].m_name);
	}
    }

    void OnDisabled() {
	log_trace("Disabling Twitch functionnalities");
	if (n_pluginId > 0) Twitch::Unregister(n_pluginId);
	n_pluginId = 0;
    }
}
#endif
