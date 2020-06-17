#!/bin/sh

wget -q --post-data="input=`cat public/css/lanyon.css`" --output-document=public/css/lanyon.min.css https://cssminifier.com/raw
wget -q --post-data="input=`cat public/css/poole.css`" --output-document=public/css/poole.min.css https://cssminifier.com/raw
wget -q --post-data="input=`cat public/css/svg-icons.css`" --output-document=public/css/svg-icons.min.css https://cssminifier.com/raw
wget -q --post-data="input=`cat public/css/syntax.css`" --output-document=public/css/syntax.min.css https://cssminifier.com/raw