export type DefaultSettingsType = {
    Size: number?,
    Color: Color3?,
    Wrapped: boolean?,
    Font: Enum.Font?,
    FontFace: Font?,
    Overfill: boolean?,
    Transparency: number?,
    Scaled: boolean?,
    XAlignment: Enum.TextXAlignment?;
    YAlignment: Enum.TextYAlignment?;
    Step: number?;
    StepLoad: number?;
    Speed: number?;
    Scale: number?;
};
export type PlayableType = {
    Play: (self: PlayableType) -> ();
    Settings: DefaultSettingsType;
    Sequence: {[any]: any};
    Destroy: (self: PlayableType) -> ();
    Break: (self: PlayableType) -> ();
    ---

    ListObject: UIListLayout;
    CurrentCharTxt: TextLabel?;
    PrevCharX: number;
    WordInstance: TextLabel;
    Word: string;
    WordLength: number;
    SequenceCount: number?;
    Count: number?;
    List: {}?;
    Timer: number?;
    CurrentIndex: number?;
    CurrentCharacterPosition: number?;
    CurrentIndexPosition: number?;
    Frame: Frame;
    CurrentStep: number?;
    CurrentSpeed: number?;
};
export type textPlusType = {
    New: (Content: string,DefaultSettings: DefaultSettingsType?) -> PlayableType
}
return nil;