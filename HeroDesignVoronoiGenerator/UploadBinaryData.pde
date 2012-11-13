import java.net.*;
import java.io.*;
import javax.imageio.*;
import javax.imageio.stream.*;
import java.awt.image.BufferedImage;

/* This class processes itself the exceptions in a rather dumb way, but in Processing, if it fails, I suppose we can
 * just ignore the issue, as we can hardly make more (beside displaying a generic error message).
 * I could make the functions throw an exception, I rejected this solution, you can implement it yourself if you feel the need.
 * Likewise, a better programming practice would have been to make an abstract class, using an abstract function to
 * write the image. Then to do two sub-classes implementing this function, one for binary blobs, another for images.
 * I took the lazy, simple way...
 */
/**
 * A rather generic class to allow uploading of data to a Web site with a PHP script on it
 * to handle this operation.
 * There is a generic method: UploadBinaryData, which accepts an array of bytes,
 * and a specialized one: UploadImage, which takes a BufferedImage, the kind provided by Processing:
 * (BufferedImage) g.image just feeds the function with the displayed image.
 *
 * Usage: create an instance, call one of the Upload functions. If it returns OK,
 * you can call GetServerFeedback to retrieve the string the server gives back
 * (likely to be the URL of the uploaded file).
 * You can also use GetResponseCode to have a status on the upload: 200 means it is OK.
 */
class DataUpload
{
  /** The field name as expected by the PHP script, equivalent to the name in the tag input type="file"
   * in an HTML upload form.
   */
//  private static final String FIELD_NAME = fileName;//"image";
 String FIELD_NAME = fileName;//"image";

  /** PHP script name. */
  // I hard-code it here, I suppose there is no need for several scripts per applet...
  private static final String SCRIPT_NAME = "Upload.php";
  /** URL path to the PHP script. */
  private static final String BASE_URL = "http://www.hero-design.com";
  private String boundary;
  private String uploadURL;
  /** The connection to the server. */
  private HttpURLConnection connection;
  /** The output stream to write the binary data. */
  private DataOutputStream output;

  DataUpload()
  {
    // Mime boundary of the various parts of the message.
    boundary = "-----DataUploadClass-----PhiLhoSoft-----" + System.currentTimeMillis();
    // We can add a optional parameters, eg. a string given by the user, parameters used, etc.
    uploadURL = BASE_URL + "/" + SCRIPT_NAME;// + "?optionalParam=value&foo=bar";
  }

  /** Pushes binary data to server. */
  boolean UploadBinaryData(String fileName, String dataMimeType, byte[] data)
  {
    try
    {
      boolean isOK = StartPOSTRequest(fileName, dataMimeType);
      if (!isOK)
        return false;
      // Spit out the data bytes at once
      output.write(data, 0, data.length);  // throws IOException
      // And actually do the send (flush output and close it)
      EndPOSTRequest();
    }
    catch (Exception e)
    {
      e.printStackTrace();
      return false; // Problem
    }
    finally
    {
      if (output != null)
      {
        try { 
          output.close();
        } 
        catch (IOException ioe) {
        }
      }
    }
    return true;  // OK
  }



  /** Reads output from server. */
  String GetServerFeedback()
  {
    if (connection == null)
    {
      // ERROR: Can't get server feedback without first uploading data!
      return null;
    }
    BufferedReader input = null;
    StringBuffer answer = new StringBuffer();
    try
    {
      input = new BufferedReader(new InputStreamReader(connection.getInputStream()));
      String answerLine = null;
      do
      {
        answerLine = input.readLine();
        if (answerLine != null)
        {
          answer.append(answerLine + "\n");
        }
      } 
      while (answerLine != null);
    }
    catch (Exception e)
    {
      // Can display some feedback to user there, or just ignore the issue
      e.printStackTrace();
      return null;  // Problem
    }
    finally
    {
      if (input != null)
      {
        try { 
          input.close();
        } 
        catch (IOException ioe) {
        }
      }
    }

    return answer.toString();
  }

  int GetResponseCode()
  {
    int responseCode = -1;
    if (connection == null)
    {
      // ERROR: Can't get server response without first uploading data!
      return -1;
    }
    // Note that 200 means OK
    try
    {
      responseCode = connection.getResponseCode();
    }
    catch (IOException ioe)
    {
    }
    return responseCode;
  }

  /*-- Private section --*/

  private boolean StartPOSTRequest(String fileName, String dataMimeType)
  {
    println("In startpostrequest");
    try
    {
      URL url = new URL(uploadURL); // throws MalformedURLException
      //      println(uploadURL);
      connection = (HttpURLConnection) url.openConnection();  // throws IOException
      // connection is probably of HttpURLConnection  type now

      connection.setDoOutput(true); // We output stuff
      connection.setRequestMethod("POST");  // With POST method
      connection.setDoInput(true);  // We want feedback!
      connection.setUseCaches(false); // No cache, it is (supposed to be) a new image each time, even if URL is always the same

        // Post multipart data
      // Set request headers
      // Might put something like "Content-Length: 8266"
      connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
      // throws IllegalStateException, NullPointerException

      // Open a stream which can write to the URL
      output = new DataOutputStream(connection.getOutputStream());
      // the get throws IOException, UnknownServiceException

      // Write content to the server, begin with the tag that says a content element is coming
      output.writeBytes("--" + boundary + "\r\n"); // throws IOException

      // Describe the content:
      // filename isn't really important here, it is probably ignored by the upload script, or can be set to user name if logged in
      output.writeBytes("Content-Disposition: form-data; name=\"" + FIELD_NAME +
        "\"; filename=\"" + fileName + "\"\r\n");
//        println("uploadbinarydata filename "+fileName);
      // Mime type of the data, like image/jpeg or image/png
      // Likely to be ignored by the PHP script (which can't trust such external info) but (might be) mandatory and nice to indicate anyway
      output.writeBytes("Content-Type: " + dataMimeType + "\r\n");
      // By default it is Base64 encoding (that's what most browsers use), but here we don't use this,
      // for simplicity sake and because it is less data to transmit. As long as destination server understands it...
      // See http://www.freesoft.org/CIE/RFC/1521/5.htm for details
      output.writeBytes("Content-Transfer-Encoding: binary\r\n\r\n");
    }
    catch (Exception e) // Indistinctly catch all kinds of exceptions this code can throw at us
    {
      // Can display some feedback to user there, or just ignore the issue
      e.printStackTrace();
      return false; // Problem
    }

    return true;
  }
  private boolean EndPOSTRequest()
  {
    try
    {
      // Close the multipart form request
      output.writeBytes("\r\n--" + boundary + "--\r\n\r\n");

      // And actually do the send (flush output and close it)
      output.flush(); // throws IOException
    }
    catch (Exception e) // Indistinctly catch all kinds of exceptions this code can throw at us
    {
      // Can display some feedback to user there, or just ignore the issue
      e.printStackTrace();
      return false; // Problem
    }

    return true;
  }
}

