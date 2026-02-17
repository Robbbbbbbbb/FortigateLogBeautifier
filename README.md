# Purpose
This script converts raw FortiGate/FortiAnalyzer logs to a cleaner format. It adds headers and arranges fields to be more easily read.

# Preview

<img width="1352" height="768" alt="image" src="https://github.com/user-attachments/assets/b292c3ce-6c72-48e3-b77b-b9cec77706d5" />

# Usage
Place the logs and the PS1 script in the same folder. Run the PS1 and enter the name of the file (if the file is named "fortigate.csv" or "logs.csv", just press enter). It then outputs the converted logs to a new file with "-converted" appended to the filename.

# Supported Fields
* Date
* Time
* Fortigate Policy ID
* Action
* Application
* Src. Country
* Dst. Country
* Src. Interface
* Dst. Interface
* Src. IP
* Dst. IP
* Src. Port
* Dst. Port
* Service
* Rcvd Bytes
* Sent Bytes
