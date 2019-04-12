class DistortManager {
  float distortionValue = 0;
  int bands = 1;
  float spectrumScaleFactor;
  float smoothingFactor;
  float[] sum = new float[bands];
  SoundFile soundScape;
  FFT fftInternal;

  DistortManager (SoundFile _s, FFT _fft,float _spectrumScaleFactor) {

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
    fftInternal.analyze();
    for (int i = 0; i < bands; i++) {
      distortionValue = fftInternal.spectrum[i]*spectrumScaleFactor;
    }
  }
}
