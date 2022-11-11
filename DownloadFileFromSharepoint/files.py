import sys
import json
from subprocess import check_output 
import os

try:
    obj = json.loads(sys.argv[1])
    if "error" in obj:
        sys.exit("Error while getting {0}. Response: {1}".format(sys.argv[2], obj["error"]["message"]))

    else:
        if "value" in obj:
            files = obj["value"]
            for file in files:
                if os.path.splitext(file["name"])[1] == sys.argv[2]:
                    out = check_output(["./process_file.sh", file["@microsoft.graph.downloadUrl"], file["name"], sys.argv[3]])
                    print(out)
        else:
            sys.exit("Error while processing {0}. Response: {1}".format(sys.argv[2], obj))
except ValueError:
    sys.exit("JSON parse error while parsing {0}. Response: {1}".format(sys.argv[2], sys.argv[1]))
except Exception as e:
    sys.exit("Error while processing {0}. Response: {1}".format(sys.argv[2], sys.argv[1]))