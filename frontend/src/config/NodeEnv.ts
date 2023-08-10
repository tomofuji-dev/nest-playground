export enum NodeEnv {
  DEV = "DEV",
  PROD = "PROD",
  TEST = "TEST"
}

export const strToNodeEnv = (str: string): NodeEnv => {
  switch (str) {
    case "DEV":
      return NodeEnv.DEV;
    case "PROD":
      return NodeEnv.PROD;
    case "TEST":
      return NodeEnv.TEST;
    default:
      throw new Error(`Unknown NodeEnv: ${str}`);
  }
};
