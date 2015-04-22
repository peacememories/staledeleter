# staledeleter
Deletes files from a folder that haven't been accessed in a while

## Building

1. Clone the git repository and go into the directory.

  ```
  git clone https://github.com/peacememories/staledeleter.git
  cd staledeleter
  ```

2. Install the package

  ```
  cabal install
  ```

## Running

```
staledeleter <directory> <time>
```

* `directory` - Directory to scan
* `time` - Time in seconds, minutes, etc.
    
    Example:
    
    ```
    4 days 2 hours 3 seconds
    ```
