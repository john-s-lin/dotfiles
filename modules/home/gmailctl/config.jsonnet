// Auto-imported filters by 'gmailctl download'.
//
// WARNING: This functionality is experimental. Before making any
// changes, check that no diff is detected with the remote filters by
// using the 'diff' command.

local colors = {
  green: {
    background: "#16a765",
    text: "#ffffff",
  },
  darkBlue: {
    background: "#0d3472",
    text: "#b6cff5",
  },
  yellow: {
    background: "#fbe983",
    text: "#594c05",
  },
  mint: {
    background: "#b3efd3",
    text: "#0b4f30",
  },
  purple: {
    background: "#b99aff",
    text: "#ffffff",
  },
  red: {
    background: "#fb4c2f",
    text: "#ffffff",
  },
  orange: {
    background: "#ffad46",
    text: "#ffffff",
  },
  lightRed: {
    background: "#fbd3e0",
    text: "#711a36",
  },
  blue: {
    background: "#4986e7",
    text: "#ffffff",
  },
  lightOrange: {
    background: "#ffdeb5",
    text: "#7a4706",
  },
};

local me = {
  or: [
    { to: 'lin.john1227@gmail.com' },
    { to: 'john.s.lin@outlook.com' },
    { to: 'j.lin1227@live.ca' },
  ],
};

local label(name, color) = {
  name: name,
  color: color,
};

local rule(filter, actions) = {
  filter: filter,
  actions: actions,
};

local labelActions(name) = {
  labels: [name],
};

local archiveRead = {
  archive: true,
  markRead: true,
};

local neverSpam = {
  markSpam: false,
};

local fromRule(sender, actions) =
  rule({ from: sender }, actions);

local fromLabelRule(sender, labelName, extraActions={}) =
  fromRule(sender, extraActions + labelActions(labelName));

{
  version: "v1alpha3",
  author: {
    name: "John Lin",
    email: "lin.john1227@gmail.com"
  },
  // Note: labels management is optional. If you prefer to use the
  // GMail interface to add and remove labels, you can safely remove
  // this section of the config.
  labels: [
    label("investments/vanguard", colors.green),
    label("church", colors.yellow),
    label("immigration/bal", colors.mint),
    label("newsletters", colors.purple),
    label("immigration", colors.mint),
    label("alerts/jobs", colors.red),
    label("alerts/science", colors.red),
    label("banking/cibc", colors.orange),
    label("alerts/github", colors.red),
    label("banking/chase", colors.orange),
    label("banking/paypal", colors.orange),
    label("alerts/charging", colors.red),
    label("purchases", colors.lightRed),
    label("purchases/camelcamelcamel", colors.lightRed),
    label("church/cbc", colors.yellow),
    label("church/gfc", colors.yellow),
    label("church/stjohns", colors.yellow),
    label("alerts/bitwarden", colors.red),
    label("investments", colors.green),
    label("investments/ibkr", colors.green),
    label("alerts/flights", colors.red),
    label("investments/questrade", colors.green),
    label("alerts", colors.red),
    label("alerts/delivery", colors.red),
    label("banking", colors.orange),
    label("meetings", colors.blue),
    label("subscriptions", colors.lightOrange),
    label("alerts/openrouter", colors.red),
    label("insurance", colors.darkBlue),
    label("insurance/fsa", colors.darkBlue),
    label("purchases/car-rental", colors.lightRed),
  ],
  rules: [
    {
      filter: {
        and: [
          {
            from: "editors-noreply@linkedin.com"
          },
          {
            query: "linkedin news"
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "newsletters"
        ]
      }
    },
    {
      filter: {
        from: "morningbrew.com"
      },
      actions: {
        markImportant: false,
        labels: [
          "newsletters"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "bytebytego@substack.com"
          },
          {
            query: "-course -enroll"
          }
        ]
      },
      actions: {
        markImportant: false,
        labels: [
          "newsletters"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "bytebytego@substack.com"
          },
          {
            query: "course OR enroll"
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false,
        labels: [
          "newsletters"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "deeplearning.ai"
          },
          {
            query: "-course -enroll"
          }
        ]
      },
      actions: {
        markImportant: false,
        labels: [
          "newsletters"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "deeplearning.ai"
          },
          {
            query: "course OR enroll"
          }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false,
        labels: [
          "newsletters"
        ]
      }
    },
    {
      filter: {
        from: "github.com"
      },
      actions: {
        labels: [
          "alerts/github"
        ]
      }
    },
    {
      filter: {
        from: "tldrnewsletter.com"
      },
      actions: {
        markImportant: false,
        labels: [
          "newsletters"
        ]
      }
    },
    {
      filter: {
        from: "chase.com"
      },
      actions: {
        labels: [
          "banking/chase"
        ]
      }
    },
    {
      filter: {
        or: [
          { from: "jobalerts-noreply@linkedin.com" },
          { from: "jobs-listings@linkedin.com" },
          { from: "jobs-noreply@linkedin.com" },
        ]
      },
      actions: {
        markImportant: false,
        labels: [
          "alerts/jobs"
        ]
      }
    },
    {
      filter: {
        from: "careers-noreply@google.com"
      },
      actions: {
        markImportant: false,
        labels: [
          "alerts/jobs"
        ]
      }
    },
    fromLabelRule("getclera.com", "alerts/jobs", archiveRead + neverSpam),
    {
      filter: {
        from: "cibc.com"
      },
      actions: {
        labels: [
          "banking/cibc"
        ]
      }
    },
    {
      filter: {
        from: "notifications@chargepoint.com"
      },
      actions: {
        markImportant: true,
        labels: [
          "alerts/charging"
        ]
      }
    },
    {
      filter: {
        from: "evgo.com"
      },
      actions: {
        labels: [
          "alerts/charging"
        ]
      }
    },
    {
      filter: {
        from: "electrifyamerica.com"
      },
      actions: {
        labels: [
          "alerts/charging"
        ]
      }
    },
    {
      filter: {
        from: "news.paypal.com"
      },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false,
      }
    },
    {
      filter: {
        or: [
          { from: "service.paypal.com" },
          { from: "service@paypal.com" },
          { from: "service@intl.paypal.com" }
        ]
      },
      actions: {
        markImportant: true,
        labels: [
          "banking/paypal"
        ]
      }
    },
    {
      filter: {
        from: "bitwarden.com"
      },
      actions: {
        labels: [
          "alerts/bitwarden"
        ]
      }
    },
    {
      filter: {
        from: "builtformars.com"
      },
      actions: {
        markImportant: false,
        labels: [
          "newsletters"
        ]
      }
    },
    fromLabelRule("hello@aaronfrancis.com", "newsletters", neverSpam),
    fromRule("aaronfrancis.com", neverSpam),
    {
      filter: {
        or: [
          { from: "aersf" },
          { from: "aliexpress.com" },
          { from: "amazon.ca" },
          { from: "amazon.com" },
          { from: "rei.com" },
          { from: "stockx.com" },
        ]
      },
      actions: {
        labels: [
          "purchases"
        ]
      }
    },
    {
      filter: {
        from: "stjohntoronto@gmail.com"
      },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false,
        labels: [
          "church/stjohns"
        ]
      }
    },
    {
      filter: {
        or: [
          { from: "creeksidebiblechurch.com" },
          { to: "cbcyoungadultministry@googlegroups.com" }
        ]
      },
      actions: {
        labels: [
          "church/cbc"
        ]
      }
    },
    {
      filter: {
        query: "{from:gfceast.ca \"Grace Fellowship Church\"}"
      },
      actions: {
        markSpam: false,
        labels: [
          "church/gfc"
        ]
      }
    },
    {
      filter: {
        from: "kayak@msg.kayak.com"
      },
      actions: {
        markImportant: false,
        labels: [
          "alerts/flights"
        ]
      }
    },
    {
      filter: {
        from: "gfceast.ca"
      },
      actions: {
        labels: [
          "church/gfc"
        ]
      }
    },
    {
      filter: {
        query: "(filename:invite.ics OR from:calendar-notification@google.com)"
      },
      actions: {
        labels: [
          "meetings"
        ]
      }
    },
    {
      filter: {
        from: "info.headspace.com"
      },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false,
        labels: [
          "subscriptions"
        ]
      }
    },
    {
      filter: {
        from: "mail.questrade.com"
      },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false,
        labels: [
          "investments/questrade"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "proxyvote"
          },
          {
            query: "questrade"
          }
        ]
      },
      actions: {
        markImportant: false,
        labels: [
          "investments/questrade"
        ]
      }
    },
    {
      filter: {
        from: "bal.com"
      },
      actions: {
        markSpam: false,
        markImportant: true,
        labels: [
          "immigration/bal"
        ]
      }
    },
    {
      filter: {
        from: "vanguard.com"
      },
      actions: {
        markSpam: false,
        labels: [
          "investments/vanguard"
        ]
      }
    },
    {
      filter: {
        from: "IQalerts@questrade.com"
      },
      actions: {
        archive: true,
        markRead: true,
        labels: [
          "investments/questrade"
        ]
      }
    },
    {
      filter: {
        from: "noreply-travel@google.com"
      },
      actions: {
        markImportant: false,
        labels: [
          "alerts/flights"
        ]
      }
    },
    {
      filter: {
        from: "alerts-noreply@clarivate.com"
      },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false,
        labels: [
          "alerts/science"
        ]
      }
    },
    {
      filter: {
        query: "camelcamelcamel.com"
      },
      actions: {
        markSpam: false,
        markImportant: false,
        labels: [
          "purchases/camelcamelcamel"
        ]
      }
    },
    {
      filter: {
        from: "balglobal.com"
      },
      actions: {
        labels: [
          "immigration/bal"
        ]
      }
    },
    {
      filter: {
        and: [
          {
            from: "mscac.utoronto.ca"
          },
          {
            query: "job"
          }
        ]
      },
      actions: {
        labels: [
          "alerts/jobs"
        ]
      }
    },
    {
      filter: {
        from: "mitacs.ca"
      },
      actions: {
        archive: true,
        markRead: true
      }
    },
    {
      filter: {
        from: "SouthwestAirlines@iluv.southwest.com"
      },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false,
        labels: [
          "alerts/flights"
        ]
      }
    },
    {
      filter: {
        from: "google-shopping-announcements-noreply@google.com"
      },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false
      }
    },
    {
      filter: {
        from: "safeway.com"
      },
      actions: {
        category: "personal",
        labels: [
          "purchases"
        ]
      }
    },
    {
      filter: {
        and: [
          { from: "apple.com" },
          { query: "receipt" }
        ]
      },
      actions: {
        labels: [
          "purchases"
        ]
      }
    },
    {
      filter: {
        and: [
          { from: "apple.com" },
          { query: "subscription -receipt" }
        ]
      },
      actions: {
        labels: [
          "subscriptions"
        ]
      }
    },
    {
      filter: {
        and: [
          { from: "openrouter.ai" },
          { to: "j.lin1227+or@live.ca" }
        ]
      },
      actions: {
        archive: true,
        markSpam: false,
        markRead: true,
        labels: [
          "alerts/openrouter"
        ]
      }
    },
    {
      filter: {
        from: "dcsg.com"
      },
      actions: {
        archive: true,
        markImportant: false,
        markRead: true,
        labels: [
          "purchases"
        ]
      }
    },
    {
      filter: {
        from: "loseit.com"
      },
      actions: {
        markImportant: false,
        markSpam: false,
        labels: [
          "subscriptions"
        ]
      }
    },
    fromLabelRule("publicmobile.ca", "subscriptions", neverSpam),
    fromLabelRule("strava.com", "subscriptions", archiveRead),
    {
      filter: {
        list: "fysk.substack.com"
      },
      actions: {
        markImportant: false,
        markRead: true,
        labels: [
          "newsletters"
        ]
      }
    },
    {
      filter: {
        from: "lemonade.com"
      },
      actions: {
        markSpam: false,
        labels: [
          "insurance"
        ]
      }
    },
    rule(
      {
        or: [
          { from: "flyporter.com" },
          { from: "jetblue.com" },
          { from: "united.com" },
        ],
      },
      labelActions("alerts/flights")
    ),
    {
      filter: {
        from: "marketing.jetblue.com"
      },
      actions: {
        archive: true,
        markImportant: false,
        markRead: true
      }
    },
    {
      filter: {
        from: "mintmobile.com"
      },
      actions: {
        markImportant: false,
        labels: [
          "subscriptions"
        ]
      }
    },
    {
      filter: {
        and: [
          { from: "doordash.com" },
          { query: "-recruiting" }
        ]
      },
      actions: {
        markImportant: false,
        markSpam: false,
        labels: [
          "purchases"
        ]
      }
    },
    {
      filter: {
        from: "trip.com"
      },
      actions: {
        markImportant: false,
        markSpam: false,
        labels: [
          "alerts/flights"
        ]
      }
    },
    {
      filter: {
        from: "truemed.com"
      },
      actions: {
        markSpam: false,
        labels: [
          "insurance/fsa"
        ]
      }
    },
    {
      filter: {
        or: [
          { from: "getbrick.com" },
          { from: "getbrick.app" },
        ]
      },
      actions: {
        markImportant: false,
        labels: [
          "purchases"
        ]
      }
    },
    {
      filter: {
        from: "chasetravel.com"
      },
      actions: {
        markSpam: false,
        markImportant: true,
        labels: [
          "alerts/flights"
        ]
      }
    },
    {
      filter: {
        from: "avis.com"
      },
      actions: {
        markSpam: false,
        labels: [
          "purchases/car-rental"
        ]
      }
    },
    {
      filter: {
        from: "interactivebrokers.com"
      },
      actions: {
        markSpam: false,
        markImportant: true,
        labels: [
          "investments/ibkr"
        ]
      }
    },
    {
      filter: {
        and: [
          { from: "bytebytego@substack.com" },
          { query: "\"continue reading\"" }
        ]
      },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false
      }
    },
    {
      filter: {
        from: "email.openai.com"
      },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false,
        labels: [
          "newsletters"
        ]
      }
    },
    rule(
      {
        and: [
          { from: "aliexpress.com" },
          { query: "delivery ship" },
        ],
      },
      labelActions("alerts/delivery")
    ),
    fromLabelRule("ups.com", "alerts/delivery")
  ]
}
