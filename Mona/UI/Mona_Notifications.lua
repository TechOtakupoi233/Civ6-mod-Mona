local MonaNotifications_RegisterHandlers = RegisterHandlers

local TradeScienceNotification = DB.MakeHash("NOTIFICATION_MONA_TRADESCIENCE")
local ResearchRewardNotification = DB.MakeHash("NOTIFICATION_MONA_RESEARCHREWARD")

function RegisterHandlers()
    MonaNotifications_RegisterHandlers()
    g_notificationHandlers[TradeScienceNotification] = MakeDefaultHandlers()
    g_notificationHandlers[ResearchRewardNotification] = MakeDefaultHandlers()
    --g_notificationHand1ers[PPK NOTIFICATION PK PROJECT LUCK TECH END].Activate = OnUserNotificationActivate
    g_notificationHandlers[TradeScienceNotification].AddSound = "ALERT_NEUTRAL"
    g_notificationHandlers[ResearchRewardNotification].AddSound = "ALERT_NEUTRAL"
end