# Coder Radio challenge - #219

https://www.reddit.com/r/CoderRadio/comments/4zwqqz/219_coding_challenge_of_destiny/

Convert an audio file to a video given a shorter video which loops continuously.

## Running with GHC

You'll first need GHC and a newer version of ffmpeg. I used version 3.1.2 of ffmpeg. Then run the following command:

```
$ ./loop_video_with_audio.hs video.mp4 audio.mp3
```

## Building and then installing the Snap

Requires Docker Compose and snapd.

Build the snap using the command `docker-compose run --rm snapcraft`.

Then install the snap with `snap install loop-video-with-audio_0.1.0_amd64.snap` or whatever the name of the snap is for you.

You should then be able to run the program with `loop-video-with-audio`.
