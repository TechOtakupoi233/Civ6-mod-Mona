function PlaySoundMona(audio)
    UI.PlaySound(audio);
end

ExposedMembers.Mona = ExposedMembers.Mona or {}
ExposedMembers.Mona.PlaySoundMona = PlaySoundMona
ExposedMembers.Mona.SelectUnitMona = SelectUnitMona