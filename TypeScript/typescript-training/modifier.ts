interface Component {
    template: string;
    data: any;
    random?: number;
    created(): void;
    render(): void;
    readonly id: number;
}

function component(options: Component) {
    options.created();
    options.render();
}