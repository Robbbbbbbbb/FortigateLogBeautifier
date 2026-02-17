# Purpose
This script converts raw fortigate logs to a cleaner format, adding headers and arranging fields to a more human-readable format. It prompts the user for the filename to convert, defaulting to "fortigate.csv" if it exists, or "logs.csv" if either exists. It then outputs the converted logs to a new file with "-converted" appended to the filename.

# Preview

<img width="1352" height="768" alt="image" src="https://github.com/user-attachments/assets/b292c3ce-6c72-48e3-b77b-b9cec77706d5" />


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
