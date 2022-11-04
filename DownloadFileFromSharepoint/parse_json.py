import sys
import json

if sys.argv[2] == "site_id" or sys.argv[2] == "drive_id":
    key = "id"
else:
    key = sys.argv[2]

try:
    obj = json.loads(sys.argv[1])
    if "error" in obj:
        sys.exit("Error while getting {0}. Response: {1}".format(sys.argv[2], obj["error"]["message"]))

    else:
        if key in obj:
            print(obj[key])
        else:
            sys.exit("Error while getting {0}. Response: {1}".format(sys.argv[2], obj))
except ValueError:
    sys.exit("JSON parse error while parsing {0}. Response: {1}".format(sys.argv[2], sys.argv[1]))
except Exception as e:
    sys.exit("Error while processing {0}. Response: {1}".format(sys.argv[2], sys.argv[1]))