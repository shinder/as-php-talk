<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>TalkServer Tester</title>
    <script type="text/javascript">
        function whenSubmit() {
            document.form1.action = document.form1.gateway.value;
            document.form1.submit();
        }
    </script>
</head>
<body>
    <form method="post" onsubmit="whenSubmit(); return false;" name="form1" id="form1">
        <label>Gateway:</label>
        <input id="gateway" name="gateway" size="80" value="exampleServer1.php" /><br>
        <label>Service command:</label>
        <input name="jsonTalk" size="80" value="multi" /><br>
        <label>Parameters (JSON):</label>
        <textarea rows="5" cols="50" name="args">[6, 8]</textarea><br>
        <input type="submit">


    </form>

</body>
</html>