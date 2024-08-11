👉 [Русский](README_RU.md) 🇷🇺

# Batch download utilities

Collection of a Windows command line utilities for batch file downloading.

## Advantages

* Portability — program doesn't need installation and works on every version of Windows since XP.
* Speed — file download processes are executed in parallel, which speeds up the results several times.
* Openness — Open source [curl](https://curl.se/) utility is used to download files.
* It's free — the software itself, as well as the curl utility, are absolutely free!

## Installation

* Download [the latest release](https://github.com/daniser/win-bdl/releases/latest).
* Extract the archive with the program into any folder convenient for you.
* For Windows versions below 10: [download curl](https://curl.se/windows/) and extract `curl.exe` into the same folder.
* _(optional)_ Add program directory to the `PATH` environment variable.
* _(optional)_ Assign `bdl.cmd` to open files with any unused extension, i.e. `.dlq`.

## Usage

### Batch Download Utility

The utility allows you to download files in batch mode by URLs from queue files,
removing target directories first (if necessary).
Downloaded files are stored into directories with names of corresponding queue files (without extension)
in current working directory. File download errors are logged into `error.log` file in the same location.

```
bdl [/u] mask [...]
/u          - queue files are in UTF-8 encoding (not supported by Windows XP)
mask        - name or mask of queue file
...         - additional names and/or masks of queue files
```

### Batch Cleanup Utility

The utility allows you to delete directories with downloaded files left over from previous downloads.
Error log file `error.log` is not deleted during this process.

```
bcl mask [...]
mask        - name or mask of queue file
...         - additional names and/or masks of queue files
```

### List Download Utility

Basic utility for batch downloading. Unlike *BDL*, target directories are not deleted before downloading,
and download errors are written to the standard error output stream _(STDERR)_.

```
ldl [/u] mask [...]
/u          - queue files are in UTF-8 encoding (not supported by Windows XP)
mask        - name or mask of queue file
...         - additional names and/or masks of queue files
```

### File Download Utility

A wrapper over curl with logging to the standard error output stream _(STDERR)_.

```
fdl url [dir [filename]]
url         - URL address of the file to download
dir         - destination directory (must exist)
filename    - destination file name
```

## Queue files

These are regular text files in `DOS` or `UTF-8` encoding.
If you need to maintain backward compatibility with Windows XP, it is recommended to use `DOS` encoding.

Each line in the queue file describes the URL of the resource to be downloaded and,
if the file needs to be saved under a different name — its destination name.
When specifying a destination file name, it is separated from the resource URL by one or more whitespace characters
(either space or a tab). If the destination file name contains spaces, it must be wrapped in double quotes.

You can use special substitution variables in both the URL and the destination file name:
* `%DAY%` — two-digit designation of the current day of the month with a leading zero (if necessary).
* `%MONTH%` — two-digit designation of the current month with a leading zero (if necessary).
* `%YEAR%` — four-digit designation of the current year.

Lines starting with a semicolon (`;`) are considered comments and are not processed.

### Queue file example

```
; let's reap icons!
https://microsoft.com/favicon.ico
https://google.com/favicon.ico      colorfulG.ico
https://github.com/favicon.ico      "octo cat.ico"
https://apple.com/favicon.ico       %YEAR%-%MONTH%-%DAY%.ico
https://yandex.ru/favicon.ico       Яндекс.ico
```
