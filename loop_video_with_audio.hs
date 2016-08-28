#!/usr/bin/env runhaskell
{-
Coder Radio Challenge for Episode #219
https://www.reddit.com/r/CoderRadio/comments/4zwqqz/219_coding_challenge_of_destiny/

Takes two inputs, a video files and an audio file, and then loops the video 
file over and over using the audio files for the audio of the video.

Example:

$ ./loop_video_with_audio.hs video.mkv audio.mp3 
video_and_audio.mkv duration is 260.781 seconds.
audio.mp3 duration is 7997.1787 seconds.
Video needs to loop at least 30.666262 times.
Creating new video which loops 31 times ...
Merging looped video with audio ...
'output.mkv' created. Give it a try!

Requirements:

 - Haskell (ghc, runhaskell)
 - ffmpeg 3.1.2 (ffmpeg, ffprobe)
-}

import System.Environment (getArgs)
import System.Process     (readProcess, callProcess)
import System.FilePath    (FilePath(..))

main :: IO ()
main = do
  -- Get audio and video file locations
  args <- getArgs
  let (video,audio) = parseArgs args

  -- Get length of video and audio files
  audioLength <- getMediaDuration audio
  videoLength <- getMediaDuration video
  putStrLn $ video ++ " duration is " ++ (show videoLength) ++ " seconds."
  putStrLn $ audio ++ " duration is " ++ (show audioLength) ++ " seconds."

  -- Create looped video file greater than length of audio
  let loopsRequired = audioLength / videoLength
  putStrLn $ "Video needs to loop at least " ++
    (show $ loopsRequired) ++ " times."
  putStrLn $ "Creating new video which loops " ++
    (show $ ceiling loopsRequired) ++ " times ..."

  callProcess "ffmpeg"
    [ "-y"
    , "-loglevel", "quiet"
    , "-fflags", "+genpts"
    , "-stream_loop", (show $ ceiling loopsRequired)
    , "-i", video
    , "-c", "copy"
    , "-an"
    , "video_loop.mkv"
    ]
  
  -- Merge looped video and audio file
  putStrLn "Merging looped video with audio ..."
  callProcess "ffmpeg"
    [ "-y"
    , "-loglevel", "quiet"
    , "-i", "video_loop.mkv"
    , "-i", audio
    , "-c", "copy"
    , "-shortest"
    , "output.mkv"
    ]

  putStrLn "'output.mkv' created. Give it a try!"

parseArgs :: [String] -> (String,String)
parseArgs (v:a:[]) = (v,a)
parseArgs _        = error
              "Invalid arguments.\n\
              \Try video file and audio file filepaths for arguments.\n\
              \Example:\n  ./loop_video_with_audio video.mkv audio.mp3"

-- Gets media duration in seconds.
type Second = Float
getMediaDuration :: FilePath -> IO Second
getMediaDuration f = readProcess "ffprobe"
  [ "-loglevel", "quiet"
  , "-show_entries"
  , "format=duration" 
  , "-of", "default=noprint_wrappers=1:nokey=1"
  , f
  ] [] >>= (\x -> return (read x :: Second))
