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
    Chunks: number?;
    Speed: number?;
    Scale: number?;
};
export type AnimatorType = {
    Letters: {TextLabel};
    Word: TextLabel;
    Destroy: (self: AnimatorType) -> ();
    AddLetter: (self: AnimatorType, Letter: TextLabel) -> ();
    Index: number;
}
export type PlayableType = {
    Play: (self: PlayableType) -> ();
    Settings: DefaultSettingsType;
    Sequence: {[any]: any};
    Destroy: (self: PlayableType) -> ();
    Break: (self: PlayableType) -> ();
    ---

    --props
    CurrentScale: number?;
    CurrentColor: Color3?;
    CurrentTransparency: number?;
    CurrentStep: number?;
    CurrentSpeed: number?;
    CurrentAmplitude: number?;
    --
    
    PrevCharacterPosition: number?;
    Chunks: number?;

    CurrentAnimations: {AnimatorType?};
    AnimationsLocked: boolean?;

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
    CurrentCharacterPosition: number;
    CurrentIndexPosition: number;
    Frame: Frame;
};
export type textPlusType = {
    New: (Content: string,DefaultSettings: DefaultSettingsType?) -> PlayableType
}
return nil;