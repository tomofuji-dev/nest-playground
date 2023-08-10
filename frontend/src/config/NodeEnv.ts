export enum NodeEnv {
  DEV = "DEV",
  PROD = "PROD",
  TEST = "TEST"
}

export const strToNodeEnv = (str: string): NodeEnv => {
  switch (str) {
    case "development":
      return NodeEnv.DEV;
    case "production":
      return NodeEnv.PROD;
    case "testing":
      return NodeEnv.TEST;
    default:
      throw new Error(`Unknown NodeEnv: ${str}`);
  }
};
