function splitStrings(value, splitValue) {
  let frames = value.match(RegExp(".{1," + splitValue + "}", "g"));
  return frames;
}
