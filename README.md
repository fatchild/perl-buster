# perl-buster
 Basic directory brute-force tool in perl

```
USAGE:
    perl perl-buster.pl [args]

EXAMPLE: 
    perl perl-buster.pl -u [BASE_URL] -w [WORDLIST]
    perl perl-buster.pl -u [BASE_URL] -w [WORDLIST] -t [TIME_BETWEEN_REQUESTS]
    perl perl-buster.pl -u [BASE_URL] -w [WORDLIST] -o [OUTPUT_FILE_PATH]
    perl perl-buster.pl -u [BASE_URL] -w [WORDLIST] -q

FLAGS: 
    -h,     help me find what this program does
    -u,     base URL
    -w,     path to the wordlist file
    -t,     time between requests, make process quieter
    -o,     relative path to output file
    -q,     quiet mode, no responses printed to console
```

## Example output

```bash
perl perl-buster.pl -u google.com -w ./common.txt -o google-dir.txt -t 0
#################################
#                               #
#         perl-buster           #
#                               #
#################################
200 -> http://google.com/
200 -> http://google.com/robots.txt
200 -> http://google.com/save
200 -> http://google.com/saved
200 -> http://google.com/saves
200 -> http://google.com/script
200 -> http://google.com/search
#################################
Time to execute: 9(s)
#################################
```

## Wordlist sources

This is by far the best resource for word lists I have found so far.
[https://github.com/gmelodie/awesome-wordlists](https://github.com/gmelodie/awesome-wordlists "The best wordlists on github").


# TODO

[ ] - Port support with default being 80  
[ ] - Ability to add accepted http response codes  
[ ] - Cookies  
[ ] - Threading   
[x] - Use HEAD instead of GET requests - dcx86r   
[ ] - "I would also suggest looking at Mojo::UserAgent, async/promises are nice to have when you start wanting to manage concurrent requests and waiting for responses." - dcx86r   
