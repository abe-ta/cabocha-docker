FROM debian:9-slim

ENV TMP_CABOCHA="/tmp/cabocha"
ENV CRF_PP="CRF++-0.58"
ENV MECAB="mecab-0.996"
ENV MECAB_IPADIC="mecab-ipadic-2.7.0-20070801"
ENV CABOCHA="cabocha-0.69"

COPY "downloads/${CRF_PP}.tar.gz" "${TMP_CABOCHA}/${CRF_PP}.tar.gz"
COPY "downloads/${MECAB}.tar.gz" "${TMP_CABOCHA}/${MECAB}.tar.gz"
COPY "downloads/${MECAB_IPADIC}.tar.gz" "${TMP_CABOCHA}/${MECAB_IPADIC}.tar.gz"
COPY "downloads/${CABOCHA}.tar.bz2" "${TMP_CABOCHA}/${CABOCHA}.tar.bz2"

ENV LANG=ja_JP.UTF-8

RUN apt-get update \
    && apt-get install --no-install-recommends -q -y \
        # For compile
        apt-utils gcc g++ make bzip2 \
        # For japanese input
        locales locales-all \
    && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=ja_JP.UTF-8 \
    && cd ${TMP_CABOCHA} \
    # CRF++
    # https://taku910.github.io/crfpp/#install
    && tar xzf "${CRF_PP}.tar.gz" \
    && ( \
        cd "${CRF_PP}" \
        && ./configure && make && make install \
    ) \
    # Mecab
    # http://taku910.github.io/mecab/#install-unix
    && tar xzf "${MECAB}.tar.gz" \
    && ( \
        cd "${MECAB}" \
        && ./configure && make && make check && make install \
        # Rebuild ldconig cache to use Mecab shared libs.
        && ldconfig \
    ) \
    # IPA dictionary
    && tar xzf "${MECAB_IPADIC}.tar.gz" \
    && ( \
        cd "${MECAB_IPADIC}" \
        && ./configure --with-charset=utf8 && make && make install \
    ) \
    # Cabocha
    # http://taku910.github.io/cabocha/
    && tar xjf "${CABOCHA}.tar.bz2" \
    && ( \
        cd "${CABOCHA}" \
        && ./configure --with-charset=utf8 && make && make check && make install \
        # Rebuild ldconfig cache to avoid error.
        && ldconfig \
    ) \
    && rm -drf ${TMP_CABOCHA} \
    && apt-get clean
