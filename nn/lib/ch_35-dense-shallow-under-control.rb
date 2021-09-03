#!/usr/bin/env ruby
# frozen_string_literal: true

require 'tensorflow'

ASCII_LOWERCASE = 'abcdefghijklmnopqrstuvwxyz'.chars # Python's list(string.ascii_lowercase)
ASCII_UPPERCASE = ASCII_LOWERCASE.map(&:upcase)
ASCII_LETTERS = ASCII_LOWERCASE + ASCII_UPPERCASE
CHARACTERS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ \t\n\r\x0b\x0c"
CHAR_INDICES = CHARACTERS.chars.each_with_index.map { |ch, i| [ch, i] }.to_h
INDICES_CHAR = CHARACTERS.chars.each_with_index.map { |ch, i| [i, ch] }.to_h

INPUT_VOCAB_SIZE = CHARACTERS.size

def encode_one_hot(line)
  x = Array.new(line.size) { Array.new(INPUT_VOCAB_SIZE, 0) }
  line.chars.each_with_index do |c, i|
    index = if CHARACTERS.include? c
              CHAR_INDICES[c]
            else
              CHAR_INDICES[' ']
            end
    x[i][index] = 1
  end
  x
end

def decode_one_hot(x)
  x.map { |onehot| onehot.rindex(onehot.max) }
   .map { |one_index| INDICES_CHAR[one_index] }
   .join ''
end

def normalization_layer_set_weights(n_layer)
  wb = []
  w = Array.new(INPUT_VOCAB_SIZE) { Array.new(INPUT_VOCAB_SIZE, 0.0) }
  b = Array.new(INPUT_VOCAB_SIZE, 0.0)
  # Let lower case letters go through
  # Let lower case letters go through
  ASCII_LOWERCASE.each do |c|
    i = CHAR_INDICES[c]
    w[i][i] = 1
  end

  # Map capitals to lower case
  ASCII_UPPERCASE.each do |c|
    i = CHAR_INDICES[c]
    il = CHAR_INDICES[c.downcase]
    w[i][il] = 1
  end
  # Map all non-letters to space
  sp_idx = CHAR_INDICES[' ']
  CHARACTERS.chars.filter { |c| !ASCII_LETTERS.include?(c) }.each do |c|
    i = CHAR_INDICES[c]
    w[i][sp_idx] = 1
  end
  wb.append(w)
  wb.append(b)
  n_layer.set_weights(wb)
  return n_layer
  # wb
end

module CH35
  class Sequential
    attr_reader :layers

    def initialize
      @layers = []
    end

    def add(layer)
      @layers << layer
    end
  end
end

def build_model() end

# dense_layer = Dense(INPUT_VOCxAB_SIZE,
#                     input_shape=(INPUT_VOCAB_SIZE,),
#                     activation='softmax')
dense_layer = Tf::Keras::Layers::Dense.new(INPUT_VOCAB_SIZE, activation: "softmax", use_bias: false ) # input_shape=(INPUT_VOCAB_SIZE,)

tensor = dense_layer.call Tf::Variable.new(encode_one_hot("line"))
puts tensor.value.inspect.size
puts tensor.value.class
puts tensor.shape
puts tensor.value[3].size

# puts dense_layer.inspect
# l = normalization_layer_set_weights dense_layer