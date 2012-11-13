import java.io.*;
import processing.core.*;
import processing.pdf.*;

public class InMemoryPGraphicsPDF extends PGraphicsPDF
{
  @Override
  protected void allocate() // Called by PGraphics in setSize()
  {
    output = new ByteArrayOutputStream(16384);
  }
  public byte[] getBytes() 
  {
    return ((ByteArrayOutputStream) output).toByteArray();
  }
}
