import java.io.*;

import processing.core.*;
import processing.pdf.*;

// New version, taking advantage of the new PGraphicsPDF implementing my previous suggestions!
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
