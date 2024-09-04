# [Web Dictaphone](http://todomvc.com), adapted for [fly.io](https://fly.io/)

This is a fork of [mdn/dom-examples/media/web-dictaphone](https://github.com/mdn/dom-examples/tree/main/media/web-dictaphone#readme), with the following additions:

* <a href="https://hexdocs.pm/ecto/Ecto.html">Ecto</a> with a <a href="https://www.postgresql.org/">PostgreSQL</a> database to persist an ordered list of clips
* <a href="https://hexdocs.pm/ex_aws_s3/ExAws.S3.html">ExAws.S3</a> with a <a href="https://www.tigrisdata.com/">Tigris</a> bucket for storing audio files
* <a href="https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html">Phoenix.PubSub</a> with <a href="https://upstash.com/">Upstash Redis</a> db and <a href="https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API">WebSockets</a> for broadcasting updates


With these changes multiple replicas of this application can be deployed, even in multiple regions.

 <p>When <code>WHISPER_URL</code> is set:</p>

<ul>
  <li>Clips that are stored in S3 Tigris will be sent to the <a href="https://github.com/rubys/cog-whisper/?tab=readme-ov-file#whisper-on-fly-gpus">Cog Whisper</a> application for transcription.</li>
  <li>Transcription results will be stored in the PostgreSQL database.</li>
  <li>Database updates will be broadcast to all connected clients.</li>
</ul>


# Deployment

In an empty directory, run:

```
fly launch --from https://github.com/fly-apps/phoenix-dictaphone.git
```

If you visit this application, you will see a standard web dictaphone example.

To create additional machines in other regions, run:

```
fly scale count 3 --region dfw,waw,syd
```

Note: By default, all machines will be configured to [automatically stop and start](https://fly.io/docs/apps/autostart-stop/).
