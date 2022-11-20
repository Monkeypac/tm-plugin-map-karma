[Setting hidden]
bool Setting_ShowKarma = true;

[Setting hidden]
bool Setting_ShowKarmaShowDetails = true;

[Setting category="Bar" name="Move karma windows"]
bool Setting_ChangeKarmaPositions = false;

[Setting category="Bar" name="Karma position" drag]
vec2 Setting_ShowKarmaPosition = vec2(50, 50);

[Setting category="Bar" name="Karma size" drag]
vec2 Setting_ShowKarmaSize = vec2(200, 70);

[Setting category="Bar" name="Karma border color" color]
vec4 Setting_ShowKarmaBorderColor = vec4(0.0f, 0.0f, 0.0f, 0.0f);

[Setting category="Bar" name="Karma background color" color]
vec4 Setting_ShowKarmaBackgroundColor = vec4(153/255.0f, 153/255.0f, 153/255.0f, 0.2f);

[Setting category="Bar" name="Karma margin" drag]
vec2 Setting_ShowKarmaMargin = vec2(10, 10);

[Setting category="Bar" name="Karma radius" drag]
vec4 Setting_ShowKarmaRadius = vec4(0.0f, 0.0f, 0.0f, 0.0f);

[Setting category="Bar" name="Karma bar radius" drag]
vec4 Setting_ShowKarmaBarRadius = vec4(0.0f, 0.0f, 0.0f, 0.0f);

[Setting category="Bar" name="Karma bar color" color]
vec4 Setting_ShowKarmaBarColor = vec4(41/255.0f, 58/255.0f, 195/255.0f, 1.0f);

[Setting category="Bar" name="Karma bar background color" color]
vec4 Setting_ShowKarmaBarBackgroundColor = vec4(153/255.0f, 153/255.0f, 153/255.0f, 0.2f);

[Setting category="Bar" name="Karma bar border color" color]
vec4 Setting_ShowKarmaBarBorderColor = vec4(3/255.0f, 6/255.0f, 36/255.0f, 1.0f);

[Setting category="Bar" name="Karma font size" drag]
int Setting_ShowKarmaFontSize = 20;

[Setting category="Bar" name="Karma text color" color]
vec4 Setting_ShowKarmaTextColor = vec4(3/255.0f, 6/255.0f, 36/255.0f, 1.0f);

[Setting category="Bar" name="Custom textures - requires reload plugin" description="If this is non null and textures are successfully loaded, they will be used instead of the above settings"]
string Setting_ShowKarmaCustomTexturesDir = "";

[Setting category="Details" name="Karma show details in bar" description="Note that setting this to true will ignore the details window position"]
bool Setting_ShowKarmaShowDetailsInBar = false;

[Setting category="Details" name="Karma details position" drag]
vec2 Setting_ShowKarmaDetailsPosition = vec2(250, 50);

[Setting category="Details" name="Karma details font size" drag]
int Setting_ShowKarmaDetailsFontSize = 20;

[Setting category="Details" name="Karma details text color" color]
vec4 Setting_ShowKarmaDetailsTextColor = vec4(3/255.0f, 6/255.0f, 36/255.0f, 1.0f);

[Setting hidden]
bool Setting_ShowLastVote = false;

[Setting category="Last vote" name="Karma last vote font size" drag]
int Setting_ShowLastVoteFontSize = 15;

[Setting category="Last vote" name="Karma last vote position" drag]
vec2 Setting_ShowLastVotePosition = vec2(50, 140);

[Setting category="Last vote" name="Karma last vote color" color]
vec4 Setting_ShowLastVoteColor = vec4(3/255.0f, 6/255.0f, 36/255.0f, 1.0f);

[Setting category="Last vote" name="Karma last vote count"]
uint Setting_ShowLastVoteCount = 5;

[Setting hidden]
bool Setting_VoteEntriesItf = false;

[Setting category="Twitch" name="Whether to send a message when votes are available for a map"]
bool Setting_SendTwitchMessageOnMapChange = false;

[Setting category="Twitch" name="Message to show when sending a vote notification on Twitch channel"]
string Setting_TwitchMessageOnMapChange = "Votes (--/-/-+/+-/+/++) enabled for map";
