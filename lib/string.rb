# frozen_string_literal: true

# Extend String class to change color of text
class String
  def red
    "\e[31m#{self}\e[0m"
  end

  def blue
    "\e[34m#{self}\e[0m"
  end

  def black
    "\e[30m#{self}\e[0m"
  end
end
