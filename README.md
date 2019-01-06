# cabocha-docker
Cabocha image based on Debian.
http://taku910.github.io/cabocha/
It contains Mecab also.
http://taku910.github.io/mecab/

# Usage
## Cabocha
echo "太郎は花子が読んでいる本を次郎に渡した" | docker run --rm -i josjos7/cabocha-docker cabocha

## Mecab
echo "太郎は花子が読んでいる本を次郎に渡した" | docker run --rm -i josjos7/cabocha-docker mecab
