enum Environment { DEV, PROD }

class Config {
  static String _environment = "";
  static Map<Map, Map<String, Map<String, String>>> _config =
      _Config.devConstants;

  static void setEnvironment(Environment envVALUE) {
    print("----------------envVALUE----------------\n$envVALUE");

    switch (envVALUE) {
      case Environment.DEV:
        _environment = "DEV";
        _config = _Config.devConstants;
        break;
      case Environment.PROD:
        _environment = "PROD";
        _config = _Config.prodConstants;
        break;
    }
  }

  static get apiBaseUrl {
    return _config[_Config.apiBaseUrl];
  }

  static get environment {
    return _environment;
  }
}

class _Config {
  static const Map<String, Map<String, String>> apiBaseUrl = {};

  static const Map<Map, Map<String, Map<String, String>>> devConstants = {
    apiBaseUrl: {
      "onboarding-service": {
        "baseUrl": "http://demo-onboarding.resettech.in/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULU9OQk9BUkRJTkctQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjUwMzQ2ODc2fQ.Ed3Z2GeZMXg_OGRMh-CH8oqukRhHlKWwrvucPAmVxYA"
      },
      "profile-service": {
        "baseUrl": "http://demo-profile.resettech.in/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVBST0ZJTEUtQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjUwMzQ3MDgzfQ.RLkjm2_yWmUSv6-Im-tkVbxVaMJO5vfp9oQCU5XL3l4"
      },
      "healing-service": {
        "baseUrl": "http://demo-healing.resettech.in/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULUhFQUxJTkctQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjUwMzQ2MDE3fQ.ShmmTrSMNhZNmiXbrVJLReYLILmFjMezt3CIkCd0vKI"
      },
      "program-service": {
        "baseUrl": "http://demo-program.resettech.in/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVBST0dSQU0tQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjUwMzQ2Mjc0fQ.bFfS9ASIkp50L7DxfsYZ_nOIy4rPZ1hS7qervcLzYx4"
      },
      "subscription-service": {
        "baseUrl": "http://demo-subscription.resettech.in/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVNVQlNDUklQVElPTi1BUEkiLCJlbnYiOiJTVEciLCJpYXQiOjE2NTAzNDczMDl9.Kjl-e_O0Y8SKt0q0DHsPJRjoB7wyVKQ9HnBeUUkq6LU"
      },
      "consultant-service": {
        "baseUrl": "http://demo-consultant.resettech.in/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULUNPTlNVTFRJTkctQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjUwMzQ2NTY2fQ.-Fob9mr_YhkVorGkzFk73Gv0MeocMOY2Vvdz_aNYEmM"
      },
      "grow-service": {
        "baseUrl": "http://demo-content.resettech.in/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULUNPTlRFTlQtQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjUwMzQ1NjQ5fQ._NKV6ZuB9VSOgf76JIjZPymCwMjQn81uMGXj43EByWU"
      },
      "app-property-service": {
        "baseUrl":
            "https://stg-configuration.aayu.live/aayu/app/json/aayu.properties.json"
      },
      "payment-service": {
        "baseUrl": "https://demo-payment.resettech.in/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVBBWU1FTlQtQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjYyMDIxNjA0fQ.fQ18MXIzNbZ3cNKhOw3KvnhoFSkZz5jRAkLDQkgYoxc"
      },
      // "event-service": {
      //   "baseUrl": "http://event-service.resettech.in/",
      //   "apiKey":
      //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVBBWU1FTlQtQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjY1NjYxMTU4fQ.usjupc2IGATDYkEKRRxNDfWD21WtT6mCs6m-fsHFndE"
      // },
      "event-service": {
        "baseUrl": "https://event-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVBBWU1FTlQtQVBJIiwiZW52IjoiVUFUIiwiaWF0IjoxNjY2MDkzNTUwfQ.TR8B7mMjt5g8DKLqgPsFmE4ern5VCoWxlQBN-PVOw-s"
      },
      "nutrition-service": {
        "baseUrl": "http://nutrition-service.resettech.in/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVRSQUlORVItQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjc4MDg4MzM5fQ.fL0lc--c4oFIQ9KZvra4SjiD65ZpJPAHU1C48x5xWfI"
      },
      "psychology-service": {
        "baseUrl": "http://psychology-service.resettech.in/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVRSQUlORVItQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjgxMzAzNDQzfQ.53NEsiHXnFAAeufSwZNHttLDB01FFAGdCVaWVAX6Atg"
      },
      "tracker-service": {
        "baseUrl": "http://tracker-service.resettech.in/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVRSQUNLRVItQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjgxMjAyODk3fQ.ir0gAEyKIob2SiLB3G_uBlP4MJrrLWZKlOVqWrJS9zs"
      },
      "loyalty-service": {
        "baseUrl": "http://loyalty-service.resettech.in/",
        "appId": "fbd96750-c3fb-11ed-85c8-9d696193b234",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULUxPWUFMVFktQVBJIiwiZW52IjoiU1RHIiwiaWF0IjoxNjc5NTcwMTI0fQ.McfoW3Df15nQnWl7Lw3CWNXhNuX0mVTUGjRZjgyaPOg"
      }
    }
  };

  static const Map<Map, Map<String, Map<String, String>>> prodConstants = {
    apiBaseUrl: {
      "onboarding-service": {
        "baseUrl": "https://onboarding-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULU9OQk9BUkRJTkctQVBJIiwiZW52IjoiVUFUIiwiaWF0IjoxNjUwODgxNzc2fQ.LBy8mVr0iJgIEOg7f6hprMu0Lpws3oDVDB1IjQqQytw"
      },
      "profile-service": {
        "baseUrl": "https://profile-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVBST0ZJTEUtQVBJIiwiZW52IjoiVUFUIiwiaWF0IjoxNjUwODkzNjcyfQ.ZUpqE51m_YhkWaTM7oXOxA5EPUU2NblpkCiGU4NaAnI"
      },
      "healing-service": {
        "baseUrl": "https://healing-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULUhFQUxJTkctQVBJIiwiZW52IjoiVUFUIiwiaWF0IjoxNjUwODkzODExfQ.IFVWeqaQ7VX8re8W2Q_loLg8fTOMTLAIE2dzeR-3fR0"
      },
      "program-service": {
        "baseUrl": "https://program-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVBST0dSQU0tQVBJIiwiZW52IjoiVUFUIiwiaWF0IjoxNjUwODkzODk2fQ.q3CbUBCpZsBkKPsf5t9IjerLZaNs_thXdd_ZFXVoES4"
      },
      "subscription-service": {
        "baseUrl": "https://subscription-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVNVQlNDUklQVElPTi1BUEkiLCJlbnYiOiJVQVQiLCJpYXQiOjE2NTA4OTM3MTV9.7SYUjCc3BiQ27CvcMpS5NcGVkzOLB-gQY4VE_O9hJwA"
      },
      "consultant-service": {
        "baseUrl": "https://consultant-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULUNPTlNVTFRJTkctQVBJIiwiZW52IjoiVUFUIiwiaWF0IjoxNjUwODkzODU2fQ.oGz_UWRuv4kirnJudb74pIziymd7hzc79YHBWkiDpLA"
      },
      "grow-service": {
        "baseUrl": "https://content-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULUNPTlRFTlQtQVBJIiwiZW52IjoiVUFUIiwiaWF0IjoxNjUwODkzOTUzfQ.meQ0bMR3zxONMQ8HCsUGhTDiz_5bzEKRhcTXIX3VFYo"
      },
      "app-property-service": {
        "baseUrl":
            "https://configuration.aayu.live/aayu/app/json/aayu.properties.json"
      },
      "payment-service": {
        "baseUrl": "https://payment.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVBBWU1FTlQtQVBJIiwiZW52IjoiVUFUIiwiaWF0IjoxNjY0Nzg2OTIzfQ.zHtDO6_OMtNTw2-ZBBq-3YwKGDXGIpMf8u26z1WkaNo"
      },
      "event-service": {
        "baseUrl": "https://event-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVBBWU1FTlQtQVBJIiwiZW52IjoiVUFUIiwiaWF0IjoxNjY2MDkzNTUwfQ.TR8B7mMjt5g8DKLqgPsFmE4ern5VCoWxlQBN-PVOw-s"
      },
      "nutrition-service": {
        "baseUrl": "https://nutrition-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVRSQUlORVItQVBJIiwiZW52IjoiUFJPRCIsImlhdCI6MTY3ODA4ODQ1Mn0.bs0rma-V128vNTTqDvNPz9UwFADyAQw4rvNPBOw_AtU"
      },
      "psychology-service": {
        "baseUrl": "https://psychology-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVRSQUlORVItQVBJIiwiZW52IjoiUFJPRCIsImlhdCI6MTY4MTMwMzQxNH0.0khA0vu7I6u-nSbTO6NPcPj7vyFVQ9jd-hXtRh_op5g"
      },
      "tracker-service": {
        "baseUrl": "https://tracker-service.aayu.live/",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULVRSQUNLRVItQVBJIiwiZW52IjoiUFJPRCIsImlhdCI6MTY4MTIwMjkwNX0.wRzJTlV9uxzSe6bFVfBpwJR8-fEZa3XviUQjSfGoZXU"
      },
      "loyalty-service": {
        "baseUrl": "https://loyalty-service.aayu.live/",
        "appId": "27680b60-d383-11ed-a3b5-07f2085b7c89",
        "apiKey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBsaWNhdGlvbiI6IlJFU0VULUxPWUFMVFktQVBJIiwiZW52IjoiUFJPRCIsImlhdCI6MTY4MDY3OTEyMn0.8VmW5Gj5BCq7KIL4NODFB1VY8kH0x2e9V_1zHo3LwvU"
      }
    }
  };
}
