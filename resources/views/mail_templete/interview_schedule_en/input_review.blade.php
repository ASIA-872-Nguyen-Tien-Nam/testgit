<style>
    p,pre {
        font-family: 'Times New Roman', Times, serif;
        font-size: 15px;
    }
</style>
<html>
    <pre style="margin: 0px;font-size: 15px;">{{$message_typ??''}}</pre>
    <p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>
</html>