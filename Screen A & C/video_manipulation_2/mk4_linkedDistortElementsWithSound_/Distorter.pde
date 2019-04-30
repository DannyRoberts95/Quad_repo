class Distorter {
  float distortionValue;
  float spectrumScaleFactor;
  float smoothingFactor;
  float[] sum = new float[bands];
  SoundFile soundScape;
  FFT fftInternal;

  Distorter (SoundFile _s, FFT _fft,float _spectrumScaleFactor) {

    distortionValue = 0;

    soundScape = _s;
    fftInternal = _fft;
    
    spectrumScaleFactor = _spectrumScaleFactor;
    smoothingFactor = 0.2;
    sum = new float[bands];

    soundScape.loop();
    fftInternal.input(soundScape);
  }

  void run() {
    fft.analyze();
    for (int i = 0; i < bands; i++) {
      distortionValue = fftInternal.spectrum[i]*spectrumScaleFactor;
      
    }
  }
}
