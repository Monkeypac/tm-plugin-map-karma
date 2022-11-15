[Setting hidden]
bool Setting_ShowKarma = true;

[Setting category="Bar" name="Karma position" drag]
vec2 Setting_ShowKarmaPosition = vec2(20, 50);

[Setting category="Bar" name="Karma size" drag]
vec2 Setting_ShowKarmaSize = vec2(100, 200);

[Setting category="Bar" name="Karma border color" color]
vec4 Setting_ShowKarmaBorderColor = vec4(0.0f, 0.0f, 0.0f, 1.0f);

[Setting category="Bar" name="Karma background color" color]
vec4 Setting_ShowKarmaBackgroundColor = vec4(0.0f, 0.0f, 0.0f, 1.0f);

[Setting category="Bar" name="Karma margin" drag]
vec2 Setting_ShowKarmaMargin = vec2(10, 10);

[Setting category="Bar" name="Karma radius" drag]
vec4 Setting_ShowKarmaRadius = vec4(0.0f, 0.0f, 0.0f, 0.0f);

[Setting category="Bar" name="Karma bar radius" drag]
vec4 Setting_ShowKarmaBarRadius = vec4(0.0f, 0.0f, 0.0f, 0.0f);

[Setting category="Bar" name="Karma bar size" drag]
vec2 Setting_ShowKarmaBarSize = vec2(10, 50);

[Setting category="Bar" name="Karma bar color" color]
vec4 Setting_ShowKarmaBarColor = vec4(0.0f, 0.0f, 0.0f, 1.0f);

[Setting category="Bar" name="Karma bar background color" color]
vec4 Setting_ShowKarmaBarBackgroundColor = vec4(0.0f, 0.0f, 0.0f, 1.0f);

[Setting category="Bar" name="Karma bar border color" color]
vec4 Setting_ShowKarmaBarBorderColor = vec4(0.0f, 0.0f, 0.0f, 1.0f);

[Setting category="Bar" name="Karma font size" drag]
int Setting_ShowKarmaFontSize = 30;

[Setting category="Bar" name="Karma text color" color]
vec4 Setting_ShowKarmaTextColor = vec4(0.0f, 0.0f, 0.0f, 1.0f);

[Setting category="Bar" name="Karma show more"]
bool Setting_ShowKarmaShowMore = true;

[Setting hidden]
bool Setting_ShowLastVote = true;

[Setting category="Last vote" name="Karma last vote font size" drag]
int Setting_ShowLastVoteFontSize = 15;

[Setting category="Last vote" name="Karma last vote position" drag]
vec2 Setting_ShowLastVotePosition = vec2(20, 100);

[Setting category="Last vote" name="Karma last vote color" color]
vec4 Setting_ShowLastVoteColor = vec4(0.0f, 0.0f, 0.0f, 1.0f);

[Setting hidden]
bool Setting_VoteEntriesItf = false;

[Setting category="Advanced" name="Whether to send a message when votes are available for a map"]
bool Setting_SendTwitchMessageOnMapChange = false;

[Setting category="Advanced" name="Message to show when sending a vote notification on Twitch channel"]
string Setting_TwitchMessageOnMapChange = "Votes (--/-/-+/+-/+/++) enabled for map";
