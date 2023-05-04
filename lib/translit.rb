# frozen_string_literal: true

module Translit # :nodoc:
  # Russian only chars: Э
  RUSSIAN_ONLY_CHARS = %w[Э э].freeze

  class << self
    def convert!(text, enforce_language = nil)
      language = if enforce_language
        enforce_input_language(enforce_language)
      else
        detect_input_language(non_empty_line(text))
      end
      enforce_language ||= language == :russian ? :english : :russian

      map = send("#{language}_to_#{enforce_language}").sort_by { |k, _| k.length }.reverse
      map.each do |translit_key, translit_value|
        text.gsub!(translit_key, translit_value.first)
      end
      text
    end

    def convert(text, enforce_language = nil)
      convert!(text.dup, enforce_language)
    end

    def non_empty_line(text)
      text.split(/\s+/).reject(&:empty?).first
    end

    def invert_character_map(map)
      map.dup.inject({}) do |acc, tuple|
        rus = tuple.last.first
        eng_value = tuple.first
        acc[rus] ? acc[rus] << eng_value : acc[rus] = [eng_value]
        acc
      end
    end

    def latin_cases(map)
      map.dup.inject({}) do |acc, tuple|
        rus_up, rus_low = tuple.last
        eng_value       = tuple.first
        acc[eng_value] = [rus_low]
        unless eng_value == eng_value.capitalize
          acc[eng_value.capitalize] = [rus_up]
        end
        acc
      end
    end

    def detect_input_language(text)
      if text && text.scan(/\w+/).empty?
        :russian
      else
        :english
      end
    end

    def enforce_input_language(language)
      if language == :english
        :russian
      else
        :english
      end
    end

    def english_to_russian
      @english_to_russian ||= latin_cases({
        "a" => ["А","а"],
        "b" => ["Б","б"],
        "c" => ["К","к"],
        "v" => ["В","в"],
        "g" => ["Г","г"],
        "d" => ["Д","д"],
        "e" => ["Е","е"],
        "yo" => ["Ё","ё"],
        "jo" => ["Ё","ё"],
        "ö" => ["Ё","ё"],
        "zh" => ["Ж","ж"],
        "z" => ["З","з"],
        "i" => ["И","и"],
        "j" => ["Й","й"],
        "k" => ["К","к"],
        "l" => ["Л","л"],
        "m" => ["М","м"],
        "n" => ["Н","н"],
        "o" => ["О","о"],
        "p" => ["П","п"],
        "r" => ["Р","р"],
        "s" => ["С","с"],
        "t" => ["Т","т"],
        "u" => ["У","у"],
        "f" => ["Ф","ф"],
        "h" => ["Х","х"],
        "x" => ["Кс","кс"],
        "ts" => ["Ц","ц"],
        "ch" => ["Ч","ч"],
        "sh" => ["Ш","ш"],
        "w" => ["В","в"],
        "shch" => ["Щ","щ"],
        "sch" => ["Щ","щ"],
        "#" => ["Ъ","ъ"],
        "y" => ["Ы","ы"],
        "'" => ["Ь","ь"],
        "je" => ["Э","э"],
        "ä" => ["Э","э"],
        "yu" => ["Ю","ю"],
        "ju" => ["Ю","ю"],
        "ü" => ["Ю","ю"],
        "ya" => ["Я","я"],
        "ja" => ["Я","я"],
        "q" => ["Я","я"]
      })
    end

    def russian_to_english
      @russian_to_english ||= invert_character_map(english_to_russian)
    end
  end
end
