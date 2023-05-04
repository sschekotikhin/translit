require 'translit'

describe 'translit' do
  let(:russian) { 'Транслитерация между кириллицей и латиницей с коммандной строки или в твоей программе' }
  let(:russian_transliteration) { 'Transliteratsiya mezhdu cirillitsej i latinitsej s commandnoj stroci ili v tvoej programme' }
  let(:english) { 'Transliteration between cyrillic <-> latin from command-line or your program' }
  let(:english_transliteration) { 'Транслитератион бетвеен кыриллик <-> латин фром комманд-лине ор ёур програм' }

  it 'transliterates from russian to english' do
    expect(Translit.convert(russian, :english)).to eq(russian_transliteration)
  end

  it 'transliterates from english to russian' do
    expect(Translit.convert(english, :russian)).to eq(english_transliteration)
  end

  describe 'edge cases' do
    it 'should handle empty strings' do
      expect(Translit.convert('', :english)).to eq('')
    end

    it 'should handle strings with empty lines' do
      expect(Translit.convert("\n\n", :english)).to eq("\n\n")
    end
  end
end
