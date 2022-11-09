import sys
import json
from subprocess import call
import os

try:
    obj = json.loads(sys.argv[1])
    if "error" in obj:
        sys.exit("Error while getting {0}. Response: {1}".format(sys.argv[2], obj["error"]["message"]))

    else:
        if "value" in obj:
            files = obj["value"]
            for file in files:
                print(os.path.splitext(file["name"]))[1]
                if os.path.splitext(file["name"])[1] == sys.argv[2]:
                    call(["./process_file.sh", file["@microsoft.graph.downloadUrl"], file["name"], sys.argv[3]])
        else:
            sys.exit("Error while processing {0}. Response: {1}".format(sys.argv[2], obj))
except ValueError:
    sys.exit("JSON parse error while parsing {0}. Response: {1}".format(sys.argv[2], sys.argv[1]))
except Exception as e:
    sys.exit("Error while processing {0}. Response: {1}".format(sys.argv[2], sys.argv[1]))