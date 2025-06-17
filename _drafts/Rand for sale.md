
Randomness, harvested from all-natural sources.
No big tech, guaranteed.

Isn't just normal random data, it's educated and cultured.
Been fed a steady stream of wikipedia, IMDB top 100 movies, and all of my classes and notes from uni.

Like a sourdough starter, this randomness has been grown and cared for over time.

Can be used for a variety of things:
* Encryption keys or one time pad
* Generative art seed data
* Used to help seed your own random number generator
* Printing out and displaying on the wall

The output is generated in batches of 10 files, each 100Kib.
It's designed so that it can fit on a single 1.44Mb floppy disk.
There is also an `info.txt` file that contains hashes for each block of randomness.

The files are secured in a zip file encrypted with the password `random`.
This is so the raw randomness isn't stored directly and isn't immediately available to the prying eyes of a passing virus or worm.

Want to bake it yourself at home?

First, feed your computer some data: `cat <files> | /dev/urandom`.
While not required, it's like adding spices to chilli, the final result tastes better if you do.

Once it's had it's fill, we can generate the files:

```
date > info.txt;
echo "sha256sum OTP_[#].bin" >> info.txt;
for i in {0..9}; do
dd if=/dev/urandom of=OTP_$i.bin bs=100KiB count=1;
sha256sum OTP_$i.bin >> info.txt;
done
zip -e `sha256sum info.txt | awk '{ print substr($0,0,12)}'`.zip -P 'random' ./info.txt ./*.bin;
rm -f ./*.bin;
rm -f info.txt;
```

You should now have a zip named after the first 12 characters of the sha256 hash of the `info.txt` file.
You access the randomness with `unzip -P 'random' <hash>.zip`.

This recipe generates 10x 100Kib `.bin` files, along with an info file containing a sha256 hash of each file.
It can be adjusted as needed for your own needs.
