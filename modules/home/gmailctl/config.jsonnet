// Auto-imported filters by 'gmailctl download'.
//
// WARNING: This functionality is experimental. Before making any
// changes, check that no diff is detected with the remote filters by
// using the 'diff' command.

// Uncomment if you want to use the standard library.
// local lib = import 'gmailctl.libsonnet';
local me = {
  or: [
    { to: 'lin.john1227@gmail.com' },
    { to: 'john.s.lin@outlook.com' },
    { to: 'j.lin1227@live.ca' },
  ],
};

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
    {
      name: "investments/vanguard",
      color: colors.green,
    },
    {
      name: "church",
      color: colors.yellow,
    },
    {
      name: "immigration/bal",
      color: colors.mint,
    },
    {
      name: "newsletters",
      color: colors.purple,
    },
    {
      name: "immigration",
      color: colors.mint,
    },
    {
      name: "alerts/jobs",
      color: colors.red,
    },
    {
      name: "alerts/science",
      color: colors.red,
    },
    {
      name: "banking/cibc",
      color: colors.orange,
    },
    {
      name: "alerts/github",
      color: colors.red,
    },
    {
      name: "banking/chase",
      color: colors.orange,
    },
    {
      name: "banking/paypal",
      color: colors.orange,
    },
    {
      name: "alerts/charging",
      color: colors.red,
    },
    {
      name: "purchases",
      color: colors.lightRed,
    },
    {
      name: "purchases/camelcamelcamel",
      color: colors.lightRed,
    },
    {
      name: "church/cbc",
      color: colors.yellow,
    },
    {
      name: "church/gfc",
      color: colors.yellow,
    },
    {
      name: "church/stjohns",
      color: colors.yellow,
    },
    {
      name: "alerts/bitwarden",
      color: colors.red,
    },
    {
      name: "investments",
      color: colors.green,
    },
    {
      name: "investments/ibkr",
      color: colors.green,
    },
    {
      name: "alerts/flights",
      color: colors.red,
    },
    {
      name: "investments/questrade",
      color: colors.green,
    },
    {
      name: "alerts",
      color: colors.red,
    },
    {
      name: "banking",
      color: colors.orange,
    },
    {
      name: "meetings",
      color: colors.blue,
    },
    {
      name: "subscriptions",
      color: colors.lightOrange,
    },
    {
      name: "alerts/openrouter",
      color: colors.red,
    },
    {
      name: "insurance",
      color: colors.darkBlue,
    },
    {
      name: "insurance/fsa",
      color: colors.darkBlue,
    },
    {
      name: "purchases/car-rental",
      color: colors.lightRed,
    }
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
        from: "jobalerts-noreply@linkedin.com OR jobs-listings@linkedin.com",
        isEscaped: true
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
    {
      filter: {
        or: [
          { from: "amazon.ca" },
          { from: "amazon.com" }
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
    {
      filter: {
        from: "jetblue.com"
      },
      actions: {
        labels: [
          "alerts/flights"
        ]
      }
    },
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
        from: "getbrick.com OR getbrick.app",
        isEscaped: true
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
    {
      filter: {
        from: "rei.com"
      },
      actions: {
        labels: [
          "purchases"
        ]
      }
    }
  ]
}
