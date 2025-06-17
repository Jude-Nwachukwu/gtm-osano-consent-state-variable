___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "DD Osano Consent State (Unofficial)",
  "categories": [
    "UTILITY"
  ],
  "description": "Use with the Osano CMP to identify the individual website user\u0027s consent state and configure when tags should execute.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "osanoConsentStateCheckType",
    "displayName": "Select Consent State Check Type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "osanoAllConsentState",
        "displayValue": "All Consent State Check"
      },
      {
        "value": "osanoSpecificConsentState",
        "displayValue": "Specific Consent State"
      }
    ],
    "simpleValueType": true,
    "help": "Select the type of consent state check you want to perform—either a specific consent category or all consent categories."
  },
  {
    "type": "RADIO",
    "name": "osanoConsentCategoryCheck",
    "displayName": "Select Consent Category",
    "radioItems": [
      {
        "value": "osanoANALYTICS",
        "displayValue": "Analytics"
      },
      {
        "value": "osanoESSENTIAL",
        "displayValue": "Essential"
      },
      {
        "value": "osanoMARKETING",
        "displayValue": "Marketing"
      },
      {
        "value": "osanoOPT_OUT",
        "displayValue": "Opt Out"
      },
      {
        "value": "osanoPERSONALIZATION",
        "displayValue": "Personalization"
      },
      {
        "value": "osanoSTORAGE",
        "displayValue": "Storage"
      }
    ],
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "osanoConsentStateCheckType",
        "paramValue": "osanoSpecificConsentState",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "osanoEnableOptionalConfig",
    "checkboxText": "Enable Optional Output Transformation",
    "simpleValueType": true
  },
  {
    "type": "GROUP",
    "name": "osanoOptionalConfig",
    "displayName": "Osano Consent State Value Tranformation",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SELECT",
        "name": "osanoAccept",
        "displayName": "Transform \"Accept\"",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "osanoAcceptGranted",
            "displayValue": "granted"
          },
          {
            "value": "osanoAcceptTrue",
            "displayValue": "true"
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "SELECT",
        "name": "osanoDeny",
        "displayName": "Transform \"Deny\"",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "osanoDenyDenied",
            "displayValue": "denied"
          },
          {
            "value": "osanoDenyFalse",
            "displayValue": "false"
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "CHECKBOX",
        "name": "osanoUndefined",
        "checkboxText": "Also transform \"undefined\" to \"denied\"",
        "simpleValueType": true
      }
    ],
    "enablingConditions": [
      {
        "paramName": "osanoEnableOptionalConfig",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const callInWindow = require('callInWindow');
const getType = require('getType');
const makeString = require('makeString');

const checkType = data.osanoConsentStateCheckType;
const categoryKey = data.osanoConsentCategoryCheck;
const enableTransform = data.osanoEnableOptionalConfig;
const transformAccept = data.osanoAccept;
const transformDeny = data.osanoDeny;
const transformUndefined = data.osanoUndefined;

// Helper: Normalize Osano category string
function getCategoryKey(rawKey) {
  return makeString(rawKey).replace('osano', '');
}

// Helper: Get consent object (from primary or fallback API)
function getConsentObject() {
  let consent = callInWindow('Osano.cm.getConsent');
  if (!consent || getType(consent) !== 'object') {
    consent = callInWindow('Osano.cm.storage.getConsent');
  }
  return consent && getType(consent) === 'object' ? consent : undefined;
}

// Helper: Apply transformation if enabled
function transformValue(val) {
  if (!enableTransform) return val;

  if (val === 'ACCEPT') {
    return transformAccept === 'osanoAcceptGranted' ? 'granted' : 'true';
  }

  if (val === 'DENY') {
    return transformDeny === 'osanoDenyDenied' ? 'denied' : 'false';
  }

  if (typeof val === 'undefined' && transformUndefined) {
    return 'denied';
  }

  return val;
}

// Main logic
const consentData = getConsentObject();
if (!consentData) return undefined;

if (checkType === 'osanoAllConsentState') {
  const result = {};
  const keys = ['ESSENTIAL', 'STORAGE', 'MARKETING', 'PERSONALIZATION', 'ANALYTICS', 'OPT_OUT'];

  keys.forEach(function (key) {
    let rawValue;
    if (typeof consentData[key] !== 'undefined') {
      rawValue = consentData[key];
    } else {
      const fallback = callInWindow('Osano.cm.storage.getConsent');
      rawValue = fallback && fallback[key];
    }
    result[key] = transformValue(rawValue);
  });

  return result;

} else if (checkType === 'osanoSpecificConsentState') {
  const category = getCategoryKey(categoryKey);
  let value;
  if (typeof consentData[category] !== 'undefined') {
    value = consentData[category];
  } else {
    const fallback = callInWindow('Osano.cm.storage.getConsent');
    value = fallback && fallback[category];
  }

  return transformValue(value);
}

return undefined;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "Osano.cm.getConsent"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "Osano.cm.storage.getConsent"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 5/20/2025, 9:26:08 AM


