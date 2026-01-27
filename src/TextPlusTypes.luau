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
    Style: ({Style: string, ["repeat"]: number?,stepfactor: number?, looped: boolean?,reverse: boolean?, delaytime: number?,amplitude: number? } | string | {string})?,
    StepFactor: number?;
    Amplitude: number?;
    StrokeColor: Color3?;
    UseCanvas: boolean?;
    StrokeTransparency: number?;
    LetterStepped: (Content: PlayableType?, Char: string?, Word: string?) -> ()?;
    OnFinished: (Content: PlayableType?) -> ()?;
    WordStepped: (Content: PlayableType?, Word: string?) -> ()?;
    ContentScaled: boolean?;
};
export type AnimatorType = {
    Letters: {TextLabel};
    Word: TextLabel;
    Destroy: (self: AnimatorType) -> ();
    AddLetter: (self: AnimatorType, Letter: TextLabel) -> ();
    Index: number;
    DefaultSize: {[TextLabel]: UDim2};
    DefaultPosition: {[TextLabel]: UDim2};
}
export type PlayableType = {
    Play: (self: PlayableType, Parent: any) -> PlayableType;
    Destroy: (self: PlayableType) -> ();
    GetIdValue: (self: PlayableType, id: string) -> (string?);
    Print: (self: PlayableType, Parent: any) -> Vector2;
    Wait: (self: PlayableType) -> ();
    Container: (Frame | CanvasGroup | {List: UIListLayout?})?;
    GetContentSize: (self: PlayableType, Parent: any) -> Vector2?;
    From: (self: PlayableType, TextLabel: TextLabel, Exclusions: (string | {string})?) -> PlayableType;
    Word: string;
};
export type textPlusType = {
    new: (Content: string,DefaultSettings: DefaultSettingsType?) -> PlayableType;
    Format: (Content: (FormatContentType) ) -> ();
    RegisterId: (Id: string, Content: any) -> (boolean?);
    UnRegisterId: (Id: string) -> ();
    RegisterStyle: (Id: string,Function: (Letter: TextLabel,Progress: number,Transparency: number, StrokeTransparency: number,Color: Color3,StrokeColor: Color3,Size: UDim2,Position: UDim2,Amplitude: number?,Reversing: boolean?) -> ()) -> ();
    UnRegisterStyle: (Id: string) -> ();
}
export type FormatContentType = {
    Image: string?,
    Font: (Enum.Font | string)?,
    FontFace: (Font | string)?,
    Color: Color3?,
    Step: number?,
    Chunks: number?,
    Scale: number?,
    Size: number?;
    Transparency: number?,
    Style: ({Style: string, ["repeat"]: number?,stepfactor: number?, looped: boolean?,reverse: boolean?, delaytime: number?,amplitude: number? } | string | {string})?,
    Amplitude: number?,
    Speed: number?,
    StepFactor: number?;
    StrokeColor: Color3?;
    StrokeTransparency: number?;
}
return nil;