
function StringBuffer(opt_a1, var_args) {
  if (opt_a1 != null) {
      this.append.apply(this, arguments);
  }
}


StringBuffer.prototype.buffer_ = '';

StringBuffer.prototype.set = function (s) {
  this.buffer_ = '' + s;
}

StringBuffer.prototype.append = function (a1, opt_a2, var_args) {
  // Use a1 directly to avoid arguments instantiation for single-arg case.
  this.buffer_ += String(a1);
  if (opt_a2 != null) {  // second argument is undefined (null == undefined)
      for (let i = 1; i < arguments.length; i++) {
          this.buffer_ += arguments[i];
      }
  }
  return this;
}

StringBuffer.prototype.clear = function() {
  this.buffer_ = '';
}

StringBuffer.prototype.getLength = function() {
  return this.buffer_.length;
}

StringBuffer.prototype.toString = function() {
  return this.buffer_;
}